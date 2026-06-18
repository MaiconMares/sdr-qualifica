class DashboardController < ApplicationController
  def index
    skip_authorization
    skip_policy_scope

    if current_user.admin?
      redirect_to admin_root_path
    else
      redirect_to dialer_path
    end
  end
end
