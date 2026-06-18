class StatisticsService
  def initialize(start_date: 30.days.ago.to_date, end_date: Date.today, sdr_id: nil)
    @start_date = start_date
    @end_date = end_date
    @sdr_id = sdr_id
  end

  def dashboard_stats
    {
      total_calls: total_calls,
      calls_today: calls_today,
      calls_by_sdr: calls_by_sdr,
      avg_call_duration: avg_call_duration,
      total_pauses: total_pauses,
      pause_reasons: pause_reasons_breakdown,
      avg_pause_duration: avg_pause_duration,
      leads_by_status: leads_by_status,
      leads_by_revenue_range: leads_by_revenue_range,
      leaderboard: leaderboard
    }
  end

  def total_calls
    call_sessions_scope.count
  end

  def calls_today
    CallSession.completed
               .where(started_at: Date.today.beginning_of_day..Date.today.end_of_day)
               .then { |s| sdr_id ? s.where(user_id: sdr_id) : s }
               .count
  end

  def calls_by_sdr
    CallSession.completed
               .in_date_range
               .joins(:user)
               .group("users.name")
               .count
               .map { |name, count| { sdr: name, calls: count } }
               .sort_by { |r| -r[:calls] }
  end

  def avg_call_duration
    avg = call_sessions_scope.average(:duration_seconds)
    avg&.round || 0
  end

  def total_pauses
    pauses_scope.count
  end

  def pause_reasons_breakdown
    pauses_scope.group(:reason).count
                .transform_keys { |k| Pause::REASON_LABELS[k.to_sym] }
  end

  def avg_pause_duration
    avg = pauses_scope.where.not(duration_seconds: nil).average(:duration_seconds)
    avg&.round || 0
  end

  def leads_by_status
    Lead.group(:status).count
        .transform_keys { |k| Lead.statuses.key(k) }
  end

  def leads_by_revenue_range
    Lead.joins(:revenue_range)
        .group("revenue_ranges.name")
        .count
        .map { |name, count| { range: name, count: count } }
  end

  def leaderboard
    CallSession.completed
               .in_date_range
               .joins(:user)
               .group("users.id, users.name")
               .select(
                 "users.id",
                 "users.name",
                 "COUNT(*) as total_calls",
                 "AVG(duration_seconds) as avg_duration",
                 "SUM(CASE WHEN leads.status = #{Lead.statuses[:agendado]} THEN 1 ELSE 0 END) as conversions"
               )
               .joins(:lead)
               .order("total_calls DESC")
               .limit(20)
  end

  private

  attr_reader :start_date, :end_date, :sdr_id

  def date_range
    start_date.beginning_of_day..end_date.end_of_day
  end

  def call_sessions_scope
    scope = CallSession.completed.where(started_at: date_range)
    sdr_id ? scope.where(user_id: sdr_id) : scope
  end

  def pauses_scope
    scope = Pause.where(started_at: date_range)
    sdr_id ? scope.where(user_id: sdr_id) : scope
  end

  module CallSessionScopeExtension
    def in_date_range
      # Used internally — caller provides date range externally
      all
    end
  end

  # Class methods for export functionality
  class << self
    def overall_statistics
      {
        total_calls: CallSession.finished.count,
        calls_per_day: CallSession.finished.where("started_at >= ?", 30.days.ago).count / 30.0,
        average_call_duration: CallSession.finished.average(:duration_seconds).to_i,
        total_pauses: Pause.count,
        average_pause_duration: Pause.where.not(duration_seconds: nil).average(:duration_seconds).to_i,
        leads_by_status: Lead.group(:status).count,
        leads_by_revenue_range: Lead.joins(:revenue_range).group("revenue_ranges.name").count
      }
    end

    def sdr_statistics
      User.sdrs.joins(:call_sessions)
          .group("users.id", "users.name")
          .select(
            "users.id",
            "users.name as user_name",
            "COUNT(call_sessions.id) as total_calls",
            "AVG(call_sessions.duration_seconds) as average_call_duration",
            "COUNT(DISTINCT pauses.id) as total_pauses",
            "SUM(COALESCE(pauses.duration_seconds, 0)) as total_pause_duration"
          )
          .left_joins(:pauses)
          .group("users.id", "users.name")
          .map do |stat|
            {
              user_name: stat.user_name,
              total_calls: stat.total_calls.to_i,
              average_call_duration: stat.average_call_duration.to_i,
              total_pauses: stat.total_pauses.to_i,
              total_pause_duration: stat.total_pause_duration.to_i,
              conversion_rate: calculate_conversion_rate(stat.user_name)
            }
          end
    end

    def revenue_range_statistics
      RevenueRange.left_joins(:leads)
                   .group("revenue_ranges.id", "revenue_ranges.name")
                   .select(
                     "revenue_ranges.name as revenue_range",
                     "COUNT(leads.id) as count",
                     "AVG(call_sessions.duration_seconds) as average_call_duration"
                   )
                   .left_joins(leads: :call_sessions)
                   .map do |stat|
                     {
                       revenue_range: stat.revenue_range,
                       count: stat.count.to_i,
                       average_call_duration: stat.average_call_duration.to_i
                     }
                   end
    end

    def daily_statistics
      CallSession.finished
                 .where("started_at >= ?", 7.days.ago)
                 .group("DATE(started_at)")
                 .select(
                   "DATE(started_at) as date",
                   "COUNT(*) as total_calls",
                   "AVG(duration_seconds) as average_call_duration"
                 )
                 .map do |stat|
                   {
                     date: stat.date,
                     total_calls: stat.total_calls.to_i,
                     average_call_duration: stat.average_call_duration.to_i,
                     total_pauses: Pause.where("DATE(started_at) = ?", stat.date).count,
                     total_pause_duration: Pause.where("DATE(started_at) = ?", stat.date).sum(:duration_seconds).to_i
                   }
                 end
                 .sort_by { |s| s[:date] }
    end

    def pause_statistics
      Pause.group(:reason)
           .select(
             "reason",
             "COUNT(*) as count",
             "AVG(duration_seconds) as average_duration"
           )
           .map do |stat|
             {
               reason: Pause::REASON_LABELS[stat.reason.to_sym] || stat.reason.to_s.humanize,
               count: stat.count.to_i,
               average_duration: stat.average_duration.to_i
             }
           end
    end

    def leaderboard
      User.sdrs.joins(:call_sessions)
          .joins("LEFT JOIN leads ON call_sessions.lead_id = leads.id")
          .group("users.id", "users.name")
          .select(
            "users.id",
            "users.name as user_name",
            "COUNT(call_sessions.id) as total_calls",
            "SUM(CASE WHEN leads.status = 'agendado' THEN 1 ELSE 0 END) as conversions"
          )
          .order("total_calls DESC")
          .limit(10)
          .map do |stat|
            {
              user_name: stat.user_name,
              total_calls: stat.total_calls.to_i,
              conversion_rate: stat.total_calls.to_i > 0 ? ((stat.conversions.to_f / stat.total_calls.to_i) * 100).round(1) : 0
            }
          end
    end

    def export_to_csv(report_type)
      case report_type
      when "overall"
        generate_overall_csv
      when "sdr"
        generate_sdr_csv
      when "daily"
        generate_daily_csv
      else
        generate_overall_csv
      end
    end

    def export_to_xlsx(report_type)
      # For now, return CSV data as XLSX requires additional gems
      # In production, you would use the 'axlsx' or 'caxlsx' gem
      export_to_csv(report_type)
    end

    private

    def calculate_conversion_rate(user_name)
      user = User.find_by(name: user_name)
      return 0 unless user

      total_calls = user.call_sessions.finished.count
      conversions = user.leads.where(status: :agendado).count
      total_calls > 0 ? ((conversions.to_f / total_calls) * 100).round(1) : 0
    end

    def generate_overall_csv
      CSV.generate(headers: true) do |csv|
        csv << ["Métrica", "Valor"]
        stats = overall_statistics
        csv << ["Total de Chamadas", stats[:total_calls]]
        csv << ["Chamadas por Dia", stats[:calls_per_day].round(2)]
        csv << ["Duração Média de Chamada", stats[:average_call_duration]]
        csv << ["Total de Pausas", stats[:total_pauses]]
        csv << ["Duração Média de Pausa", stats[:average_pause_duration]]
        csv << []
        csv << ["Status", "Quantidade"]
        stats[:leads_by_status].each { |status, count| csv << [status.humanize, count] }
      end
    end

    def generate_sdr_csv
      CSV.generate(headers: true) do |csv|
        csv << ["SDR", "Total de Chamadas", "Duração Média", "Total de Pausas", "Tempo de Pausa", "Taxa de Conversão"]
        sdr_statistics.each do |stat|
          csv << [
            stat[:user_name],
            stat[:total_calls],
            stat[:average_call_duration],
            stat[:total_pauses],
            stat[:total_pause_duration],
            stat[:conversion_rate]
          ]
        end
      end
    end

    def generate_daily_csv
      CSV.generate(headers: true) do |csv|
        csv << ["Data", "Total de Chamadas", "Duração Média", "Total de Pausas", "Tempo de Pausa"]
        daily_statistics.each do |stat|
          csv << [
            stat[:date],
            stat[:total_calls],
            stat[:average_call_duration],
            stat[:total_pauses],
            stat[:total_pause_duration]
          ]
        end
      end
    end
  end
end
