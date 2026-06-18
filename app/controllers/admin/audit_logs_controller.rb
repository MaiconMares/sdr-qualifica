class Admin::AuditLogsController < Admin::BaseController
  before_action :set_audit_log, only: %i[show]

  def index
    authorize :admin_audit_log, :index?
    
    @audit_logs = AuditLog.includes(:user, :auditable).order(created_at: :desc)
    
    # Filters
    @audit_logs = @audit_logs.where(action: params[:action]) if params[:action].present?
    @audit_logs = @audit_logs.where(user_id: params[:user_id]) if params[:user_id].present?
    @audit_logs = @audit_logs.where("auditable_type = ?", params[:auditable_type]) if params[:auditable_type].present?
    @audit_logs = @audit_logs.where(created_at: params[:start_date]..params[:end_date]) if params[:start_date].present? && params[:end_date].present?
    
    @pagy, @audit_logs = pagy(@audit_logs, items: 50)
    
    @users = User.all
    @actions = AuditLog.distinct.pluck(:action)
  end

  def show
    authorize @audit_log, :show?
  end

  private

  def set_audit_log
    @audit_log = AuditLog.find(params[:id])
  end

end
