class Admin::KanbansController < Admin::BaseController

  def show
    authorize :admin_kanban, :show?

    @leads = Lead.includes(:revenue_range, current_assignment: :user).order(updated_at: :desc)

    @leads = @leads.where(status: params[:status]) if params[:status].present?
    @leads = @leads.joins(:lead_assignments).where(lead_assignments: { user_id: params[:sdr_id] }) if params[:sdr_id].present?
    @leads = @leads.where(revenue_range_id: params[:revenue_range_id]) if params[:revenue_range_id].present?
    if params[:q].present?
      @leads = @leads.where("contact_name ILIKE ? OR company_name ILIKE ?",
                            "%#{params[:q]}%", "%#{params[:q]}%")
    end

    @columns         = Lead.statuses.keys
    @leads_by_status = @leads.group_by(&:status)
    @total_leads     = @leads.size
    @loaded_at       = Time.current
    @sdrs            = User.active_sdrs
    @revenue_ranges  = RevenueRange.all
  end

  def move
    authorize :admin_kanban, :move?
    
    lead = Lead.find(params[:lead_id])
    new_status = params[:new_status]
    
    result = KanbanMovementService.call(
      lead: lead,
      new_status: new_status,
      user: current_user,
      request: request
    )
    
    if result.success?
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "lead_#{lead.id}",
            partial: "admin/kanbans/lead_card",
            locals: { lead: lead.reload }
          )
        end
      end
    else
      render json: { error: result.error_message }, status: :unprocessable_entity
    end
  end

  private

end
