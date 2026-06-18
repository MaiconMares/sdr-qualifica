class Admin::BaseController < ApplicationController
  layout "admin"

  before_action :require_admin

  skip_after_action :verify_authorized, raise: false
  skip_after_action :verify_policy_scoped, raise: false

  private

  def require_admin
    redirect_to root_path, alert: "Acesso negado." unless current_user&.admin?
  end
end
