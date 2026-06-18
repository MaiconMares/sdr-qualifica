module ApplicationHelper
  AVATAR_COLORS = %w[
    bg-blue-500 bg-green-600 bg-amber-500 bg-red-500
    bg-purple-500 bg-orange-500 bg-teal-500 bg-pink-500
  ].freeze

  KANBAN_STATUS_CONFIG = {
    "sem_contato"    => { dot: "bg-slate-400",  border: "border-t-slate-400",  label: "Sem contato" },
    "tentativa"      => { dot: "bg-amber-500",  border: "border-t-amber-500",  label: "Tentativa" },
    "remarcado"      => { dot: "bg-blue-500",   border: "border-t-blue-500",   label: "Remarcado" },
    "agendado"       => { dot: "bg-green-500",  border: "border-t-green-500",  label: "Agendado" },
    "desqualificado" => { dot: "bg-red-500",    border: "border-t-red-500",    label: "Desqualificado" },
    "excluido"       => { dot: "bg-slate-600",  border: "border-t-slate-600",  label: "Excluído" }
  }.freeze

  def user_avatar_color(user_id)
    AVATAR_COLORS[user_id.to_i % AVATAR_COLORS.length]
  end

  def user_initials(name)
    name.to_s.split.map(&:first).first(2).join.upcase
  end

  def kanban_status_config(status)
    KANBAN_STATUS_CONFIG[status.to_s] ||
      { dot: "bg-slate-400", border: "border-t-slate-400", label: status.to_s.humanize }
  end

  def time_ago_pt(time)
    return "agora" if time.nil?
    diff = Time.current - time
    case diff
    when 0..59        then "há #{diff.to_i}s"
    when 60..3599     then "há #{(diff / 60).to_i}min"
    when 3600..86_399 then "há #{(diff / 3600).to_i}h"
    else                   "há #{(diff / 86_400).to_i}d"
    end
  end

  def format_duration(seconds)
    return "00:00:00" if seconds.nil? || seconds.zero?
    
    hours = seconds.to_i / 3600
    minutes = (seconds.to_i % 3600) / 60
    secs = seconds.to_i % 60
    
    format("%02d:%02d:%02d", hours, minutes, secs)
  end

  def lead_status_class(status)
    case status.to_s
    when 'sem_contato'
      'bg-gray-500/20 text-gray-300'
    when 'tentativa'
      'bg-blue-500/20 text-blue-300'
    when 'remarcado'
      'bg-yellow-500/20 text-yellow-300'
    when 'agendado'
      'bg-green-500/20 text-green-300'
    when 'desqualificado'
      'bg-red-500/20 text-red-300'
    when 'excluido'
      'bg-purple-500/20 text-purple-300'
    else
      'bg-gray-500/20 text-gray-300'
    end
  end

  def import_status_class(status)
    case status.to_s
    when 'pending'
      'bg-yellow-500/20 text-yellow-300'
    when 'processing'
      'bg-blue-500/20 text-blue-300'
    when 'completed'
      'bg-green-500/20 text-green-300'
    when 'failed'
      'bg-red-500/20 text-red-300'
    else
      'bg-gray-500/20 text-gray-300'
    end
  end

  def audit_action_class(action)
    case action.to_s
    when 'call_started'
      'bg-green-500/20 text-green-300'
    when 'call_ended'
      'bg-red-500/20 text-red-300'
    when 'status_changed'
      'bg-blue-500/20 text-blue-300'
    when 'lead_imported'
      'bg-purple-500/20 text-purple-300'
    when 'lead_assigned'
      'bg-yellow-500/20 text-yellow-300'
    when 'pause'
      'bg-orange-500/20 text-orange-300'
    when 'resume'
      'bg-green-500/20 text-green-300'
    else
      'bg-gray-500/20 text-gray-300'
    end
  end
end
