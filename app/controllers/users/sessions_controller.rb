class Users::SessionsController < Devise::SessionsController
  def create
    super do |user|
      AuditLogService.log(
        action: :login,
        user: user,
        request: request
      )
      WorkSessionService.start(user: user, request: request) if user.sdr? && user.pending_leads_count > 0
    end
  end

  def index; end

  def destroy
    AuditLogService.log(
      action: :logout,
      user: current_user,
      request: request
    )
    super
  end
end
