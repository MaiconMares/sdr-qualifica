class DialersController < ApplicationController
  skip_after_action :verify_policy_scoped, raise: false
  skip_after_action :verify_authorized, raise: false

  def show
    authorize :dialer, :show?

    @work_session = current_user.current_work_session
    @current_lead = current_lead_for_sdr
    @queue_count  = current_user.pending_leads_count
    @active_pause = current_user.active_pause
    @pause_reasons = Pause::REASON_LABELS
  end

  def start_call
    authorize :dialer, :update?

    lead = current_user.leads.find(params[:lead_id])
    work_session = current_user.current_work_session

    call_session = CallSession.create!(
      lead: lead,
      user: current_user,
      work_session: work_session,
      started_at: Time.current,
      status: :in_progress
    )

    AuditLogService.log(
      action: :call_started,
      user: current_user,
      auditable: call_session,
      request: request
    )

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "dialer_card",
          partial: "dialers/lead_card",
          locals: { lead: lead, call_session: call_session }
        )
      end
    end
  end

  def end_call
    authorize :dialer, :update?

    lead        = current_user.leads.find(params[:lead_id])
    new_status  = params[:status]
    description = params[:description]

    result = CallCompletionService.call(
      user: current_user,
      lead: lead,
      new_status: new_status,
      description: description,
      request: request
    )

    if result.success?
      respond_to do |format|
        format.turbo_stream do
          next_lead = current_lead_for_sdr
          streams = [
            turbo_stream.replace("queue_counter", partial: "dialers/queue_counter",
              locals: { count: current_user.reload.pending_leads_count }),
            turbo_stream.replace("dialer_card", partial: "dialers/lead_card",
              locals: { lead: next_lead, call_session: nil })
          ]
          render turbo_stream: streams
        end
      end
    else
      render json: { error: result.error_message }, status: :unprocessable_entity
    end
  end

  def pause
    authorize :dialer, :update?

    result = PauseService.call(
      user: current_user,
      reason: params[:reason],
      description: params[:description],
      request: request
    )

    if result.success?
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("pause_button", partial: "dialers/resume_button"),
            turbo_stream.replace("timer_section", partial: "dialers/timer",
              locals: { work_session: current_user.reload.current_work_session })
          ]
        end
      end
    else
      render json: { error: result.error_message }, status: :unprocessable_entity
    end
  end

  def resume
    authorize :dialer, :update?

    result = ResumeService.call(user: current_user, request: request)

    if result.success?
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("pause_button", partial: "dialers/pause_button"),
            turbo_stream.replace("timer_section", partial: "dialers/timer",
              locals: { work_session: current_user.reload.current_work_session })
          ]
        end
      end
    else
      render json: { error: result.error_message }, status: :unprocessable_entity
    end
  end

  def timer_state
    authorize :dialer, :show?

    work_session = current_user.current_work_session
    render json: {
      status:          work_session&.status,
      elapsed_seconds: work_session&.elapsed_seconds.to_i,
      paused:          work_session&.paused?,
      started_at:      work_session&.started_at&.iso8601
    }
  end

  private

  def current_lead_for_sdr
    current_user.lead_assignments
                .active
                .ordered
                .joins(:lead)
                .where(leads: { status: :sem_contato })
                .includes(lead: [ :revenue_range ])
                .first
                &.lead
  end
end
