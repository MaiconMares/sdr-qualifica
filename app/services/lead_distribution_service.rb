class LeadDistributionService < ApplicationService
  def initialize(leads:, sdrs:, assigned_by: nil)
    @leads = leads
    @sdrs = sdrs.to_a
    @assigned_by = assigned_by
  end

  def call
    return failure("Nenhum SDR ativo disponível") if @sdrs.empty?
    return failure("Nenhum lead para distribuir") if @leads.empty?

    assignments = build_assignments
    persist_assignments(assignments)
    success(assignments)
  end

  private

  attr_reader :leads, :sdrs, :assigned_by

  def build_assignments
    grouped = group_by_revenue_range(leads)
    sdr_buckets = initialize_buckets

    grouped.each_value do |bucket_leads|
      distribute_bucket(bucket_leads, sdr_buckets)
    end

    sdr_buckets
  end

  def group_by_revenue_range(leads)
    leads.group_by { |l| l.revenue_range_id.to_s }
  end

  def initialize_buckets
    sdrs.each_with_object({}) { |sdr, h| h[sdr.id] = [] }
  end

  def distribute_bucket(bucket_leads, sdr_buckets)
    sorted_sdrs = sdrs.sort_by { |sdr| sdr_buckets[sdr.id].length }

    bucket_leads.each_with_index do |lead, i|
      sdr = sorted_sdrs[i % sorted_sdrs.length]
      sdr_buckets[sdr.id] << lead
    end
  end

  def persist_assignments(sdr_buckets)
    now = Time.current

    ActiveRecord::Base.transaction do
      lead_ids = sdr_buckets.values.flatten.map(&:id)
      LeadAssignment.where(lead_id: lead_ids, active: true).update_all(active: false)

      inserts = []
      sdr_buckets.each do |sdr_id, bucket_leads|
        bucket_leads.each_with_index do |lead, position|
          inserts << {
            lead_id:      lead.id,
            user_id:      sdr_id,
            assigned_by_id: assigned_by&.id,
            position:     position,
            active:       true,
            assigned_at:  now,
            created_at:   now,
            updated_at:   now
          }
        end
      end

      LeadAssignment.insert_all(inserts) if inserts.any?

      AuditLogService.log(
        action: :lead_assigned,
        user: assigned_by,
        metadata: { count: inserts.length, sdr_count: sdrs.length }
      )
    end
  end
end
