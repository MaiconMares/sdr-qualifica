class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: %i[show edit update activate deactivate]

  def index
    authorize :admin_user, :index?
    @users = User.order(:name)
    @pagy, @users = pagy(@users, items: 20)
  end

  def show
    authorize @user, :show?
    @user_stats = StatisticsService.user_statistics(@user)
  end

  def new
    authorize User, :create?
    @user = User.new
  end

  def create
    authorize User, :create?
    @user = User.new(user_params)

    if @user.save
      AuditLogService.log(
        action: :user_created,
        user: current_user,
        auditable: @user,
        request: request
      )
      redirect_to admin_user_path(@user), notice: "Usuário criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @user, :update?
  end

  def update
    authorize @user, :update?

    if @user.update(user_params)
      AuditLogService.log(
        action: :user_updated,
        user: current_user,
        auditable: @user,
        request: request
      )
      redirect_to admin_user_path(@user), notice: "Usuário atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def activate
    authorize @user, :activate?
    @user.update(active: true)
    
    AuditLogService.log(
      action: :user_activated,
      user: current_user,
      auditable: @user,
      request: request
    )
    
    redirect_to admin_users_path, notice: "Usuário ativado com sucesso."
  end

  def deactivate
    authorize @user, :deactivate?
    @user.update(active: false)
    
    AuditLogService.log(
      action: :user_deactivated,
      user: current_user,
      auditable: @user,
      request: request
    )
    
    redirect_to admin_users_path, notice: "Usuário desativado com sucesso."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation,
      :role,
      :active,
      :session_timeout_minutes
    )
  end

end
