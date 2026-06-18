class Admin::LeadsController < Admin::BaseController
  before_action :set_lead, only: %i[show update reassign]

  def index
    authorize :admin_lead, :index?
    
    @leads = Lead.includes(:revenue_range, :lead_assignments).order(created_at: :desc)
    
    # Filters
    @leads = @leads.where(status: params[:status]) if params[:status].present?
    @leads = @leads.joins(:lead_assignments).where(lead_assignments: { user_id: params[:sdr_id] }) if params[:sdr_id].present?
    @leads = @leads.where(revenue_range_id: params[:revenue_range_id]) if params[:revenue_range_id].present?
    @leads = @leads.where("city ILIKE ?", "%#{params[:city]}%") if params[:city].present?
    
    @pagy, @leads = pagy(@leads, items: 20)
    
    @sdrs = User.active_sdrs
    @revenue_ranges = RevenueRange.all
  end

  def show
    authorize @lead, :show?
    @status_history = @lead.lead_status_histories.order(created_at: :desc)
    @call_sessions = @lead.call_sessions.order(created_at: :desc)
  end

  def update
    authorize @lead, :update?
    
    if @lead.update(lead_params)
      AuditLogService.log(
        action: :status_changed,
        user: current_user,
        auditable: @lead,
        request: request,
        metadata: { previous_status: @lead.status_before_last_save, new_status: @lead.status }
      )
      redirect_to admin_lead_path(@lead), notice: "Lead atualizado com sucesso."
    else
      render :show, status: :unprocessable_entity
    end
  end

  def redistribute
    authorize :admin_lead, :redistribute?
    
    result = LeadDistributionService.call
    
    if result.success?
      AuditLogService.log(
        action: :lead_redistributed,
        user: current_user,
        request: request,
        metadata: { redistributed_count: result.redistributed_count }
      )
      redirect_to admin_leads_path, notice: "#{result.redistributed_count} leads redistribuídos com sucesso."
    else
      redirect_to admin_leads_path, alert: result.error_message
    end
  end

  def reassign
    authorize @lead, :reassign?
    
    new_sdr = User.find(params[:user_id])
    
    @lead.lead_assignments.active.update_all(active: false, ended_at: Time.current)
    
    LeadAssignment.create!(
      lead: @lead,
      user: new_sdr,
      active: true,
      started_at: Time.current
    )
    
    AuditLogService.log(
      action: :lead_assigned,
      user: current_user,
      auditable: @lead,
      request: request,
      metadata: { assigned_to: new_sdr.id }
    )
    
    redirect_to admin_lead_path(@lead), notice: "Lead reatribuído para #{new_sdr.name}."
  end

  private

  def set_lead
    @lead = Lead.find(params[:id])
  end

  def lead_params
    params.require(:lead).permit(:status, :notes)
  end

end
