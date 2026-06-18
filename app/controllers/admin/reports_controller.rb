class Admin::ReportsController < Admin::BaseController

  def show
    authorize :admin_report, :show?
    
    @statistics = StatisticsService.overall_statistics
    @sdr_statistics = StatisticsService.sdr_statistics
    @revenue_statistics = StatisticsService.revenue_range_statistics
    @daily_statistics = StatisticsService.daily_statistics
    @pause_statistics = StatisticsService.pause_statistics
    @leaderboard = StatisticsService.leaderboard
  end

  def export_csv
    authorize :admin_report, :export?
    
    csv_data = StatisticsService.export_to_csv(params[:report_type])
    
    send_data csv_data,
              filename: "relatorio_#{params[:report_type]}_#{Date.current}.csv",
              type: "text/csv",
              disposition: "attachment"
  end

  def export_xlsx
    authorize :admin_report, :export?
    
    xlsx_data = StatisticsService.export_to_xlsx(params[:report_type])
    
    send_data xlsx_data,
              filename: "relatorio_#{params[:report_type]}_#{Date.current}.xlsx",
              type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
              disposition: "attachment"
  end

  private

end
