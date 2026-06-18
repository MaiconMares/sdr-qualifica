class Admin::RevenueRangesController < Admin::BaseController
  before_action :set_revenue_range, only: %i[show edit update]

  def index
    authorize :admin_revenue_range, :index?
    @revenue_ranges = RevenueRange.order(:name)
  end

  def show
    authorize @revenue_range, :show?
    @leads_count = @revenue_range.leads.count
    @average_call_duration = CallSession.joins(:lead).where(leads: { revenue_range: @revenue_range }).average(:duration_seconds)
  end

  def new
    authorize RevenueRange, :create?
    @revenue_range = RevenueRange.new
  end

  def create
    authorize RevenueRange, :create?
    @revenue_range = RevenueRange.new(revenue_range_params)

    if @revenue_range.save
      redirect_to admin_revenue_range_path(@revenue_range), notice: "Faixa de faturamento criada com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @revenue_range, :update?
  end

  def update
    authorize @revenue_range, :update?

    if @revenue_range.update(revenue_range_params)
      redirect_to admin_revenue_range_path(@revenue_range), notice: "Faixa de faturamento atualizada com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_revenue_range
    @revenue_range = RevenueRange.find(params[:id])
  end

  def revenue_range_params
    params.require(:revenue_range).permit(:name, :min_value, :max_value)
  end

end
