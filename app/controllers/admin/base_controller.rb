class Admin::BaseController < ApplicationController
  layout "admin"

  before_action :require_admin
  before_action :skip_policy_scope

  private

  def require_admin
    redirect_to root_path, alert: "Acesso negado." unless current_user&.admin?
  end
end
