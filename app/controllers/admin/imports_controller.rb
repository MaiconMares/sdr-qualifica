class Admin::ImportsController < Admin::BaseController
  before_action :set_import, only: %i[show destroy status]

  def index
    authorize :admin_import, :index?

    @latest_import   = Import.order(created_at: :desc).first
    @active_sdrs     = User.active_sdrs
    @revenue_ranges  = RevenueRange.order(:min_value)
    @total_leads     = Lead.count
    @total_ranges    = @revenue_ranges.count
    @avg_per_sdr     = @active_sdrs.any? ? (@total_leads.to_f / @active_sdrs.count).round : 0

    counts = LeadAssignment
               .where(active: true)
               .joins(:lead)
               .where(user_id: @active_sdrs.map(&:id))
               .group(:user_id, "leads.revenue_range_id")
               .count

    @distribution = Hash.new { |h, k| h[k] = Hash.new(0) }
    counts.each { |(uid, rrid), c| @distribution[uid][rrid] = c }

    @sdr_totals   = @active_sdrs.index_with { |s| @distribution[s.id].values.sum }
    @range_totals = @revenue_ranges.index_with { |r| @active_sdrs.sum { |s| @distribution[s.id][r.id] } }
  end

  def show
    authorize @import, :show?
  end

  def create
    authorize Import, :create?
    
    if params[:file].blank?
      redirect_to admin_imports_path, alert: "Por favor, selecione um arquivo."
      return
    end

    import = Import.new(
      file: params[:file],
      user: current_user,
      status: :pending,
      filename: params[:file].original_filename
    )

    if import.save
      ImportJob.perform_later(import.id)
      
      AuditLogService.log(
        action: :lead_imported,
        user: current_user,
        auditable: import,
        request: request
      )
      
      redirect_to admin_imports_path, notice: "Importação iniciada com sucesso."
    else
      redirect_to admin_imports_path, alert: "Erro ao criar importação: #{import.errors.full_messages.join(', ')}"
    end
  end

  def destroy
    authorize @import, :destroy?
    
    if @import.pending?
      @import.destroy
      redirect_to admin_imports_path, notice: "Importação cancelada com sucesso."
    else
      redirect_to admin_imports_path, alert: "Não é possível excluir importações processadas."
    end
  end

  def status
    authorize @import, :show?
    
    render json: {
      id: @import.id,
      status: @import.status,
      progress: @import.progress,
      total_rows: @import.total_rows,
      processed_rows: @import.processed_rows,
      failed_rows: @import.failed_rows,
      error_message: @import.error_message
    }
  end

  private

  def set_import
    @import = Import.find(params[:id])
  end

end
