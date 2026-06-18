class CallCompletionService < ApplicationService
  def initialize(user:, lead:, new_status:, description: nil, request: nil)
    @user = user
    @lead = lead
    @new_status = new_status.to_s
    @description = description
    @request = request
  end

  def call
    return failure("Lead não encontrado") unless lead
    return failure("Status inválido") unless Lead.statuses.key?(@new_status)
    return failure("Transição de status inválida") unless lead.can_transition_to?(@new_status)

    ActiveRecord::Base.transaction do
      end_active_call_session
      update_lead_status
      record_status_history
      update_assignment_position
    end

    success(lead)
  end

  private

  attr_reader :user, :lead, :description, :request

  def end_active_call_session
    active_session = CallSession.where(lead: lead, user: user, status: :in_progress).first
    active_session&.end!
  end

  def update_lead_status
    previous = lead.status
    lead.update!(status: @new_status, last_interaction_at: Time.current)

    AuditLogService.log(
      action: :status_changed,
      user: user,
      auditable: lead,
      metadata: { from: previous, to: @new_status },
      request: request
    )
  end

  def record_status_history
    LeadStatusHistory.create!(
      lead: lead,
      changed_by: user,
      previous_status: Lead.statuses[lead.status_before_last_save || lead.status_was],
      new_status: Lead.statuses[@new_status],
      description: description,
      changed_at: Time.current
    )
  end

  def update_assignment_position
    assignment = LeadAssignment.where(lead: lead, user: user, active: true).first
    return unless assignment

    max_pos = LeadAssignment.where(user: user, active: true).maximum(:position).to_i
    assignment.update!(position: max_pos + 1)
  end
end
