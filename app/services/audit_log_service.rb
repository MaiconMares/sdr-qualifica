class AuditLogService
  def self.log(action:, user: nil, auditable: nil, metadata: {}, request: nil)
    AuditLog.create!(
      user: user,
      action: action,
      auditable_type: auditable&.class&.name,
      auditable_id: auditable&.id,
      metadata: metadata,
      ip_address: request&.remote_ip,
      user_agent: request&.user_agent,
      occurred_at: Time.current
    )
  rescue => e
    Rails.logger.error("AuditLogService failed: #{e.message}")
  end
end
