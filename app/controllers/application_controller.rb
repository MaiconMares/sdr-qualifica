class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Pagy::Backend

  allow_browser versions: :modern
  stale_when_importmap_changes

  before_action :authenticate_user!
  before_action :check_session_timeout
  before_action :set_current_user_for_audit

  after_action :verify_authorized, except: :index, unless: :skip_authorization?
  after_action :verify_policy_scoped, only: :index, unless: :skip_authorization?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def check_session_timeout
    return unless current_user

    timeout_minutes = current_user.session_timeout_minutes
    last_seen = session[:last_seen_at]

    if last_seen && (Time.current - Time.parse(last_seen.to_s)) > timeout_minutes.minutes
      sign_out current_user
      redirect_to new_user_session_path, alert: "Sua sessão expirou. Por favor, faça login novamente."
      return
    end

    session[:last_seen_at] = Time.current.iso8601
  end

  def set_current_user_for_audit
    Current.user = current_user if defined?(Current)
  end

  def user_not_authorized
    respond_to do |format|
      format.html { redirect_to root_path, alert: "Você não tem permissão para acessar esta página." }
      format.turbo_stream { render turbo_stream: turbo_stream.replace("flash", partial: "shared/flash", locals: { alert: "Acesso negado." }) }
      format.json { render json: { error: "Não autorizado" }, status: :forbidden }
    end
  end

  def record_not_found
    respond_to do |format|
      format.html { redirect_to root_path, alert: "Registro não encontrado." }
      format.json { render json: { error: "Não encontrado" }, status: :not_found }
    end
  end

  def skip_authorization?
    devise_controller? || self.class == RailsHealthCheckController rescue false
  end
end
