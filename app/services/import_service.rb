class ImportService < ApplicationService
  ALLOWED_EXTENSIONS = %w[csv xlsx xls].freeze
  ALLOWED_MIME_TYPES = %w[
    text/csv
    application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
    application/vnd.ms-excel
  ].freeze

  COLUMN_MAP = {
    "company_name"    => :company_name,
    "empresa"         => :company_name,
    "razao_social"    => :company_name,
    "contact_name"    => :contact_name,
    "contato"         => :contact_name,
    "nome"            => :contact_name,
    "phone"           => :phone,
    "telefone"        => :phone,
    "celular"         => :phone,
    "email"           => :email,
    "e-mail"          => :email,
    "e_mail"          => :email,
    "city"            => :city,
    "cidade"          => :city,
    "state"           => :state,
    "estado"          => :state,
    "uf"              => :state,
    "revenue_range"   => :revenue_range,
    "faturamento"     => :revenue_range,
    "faixa_faturamento" => :revenue_range
  }.freeze

  def initialize(import:)
    @import = import
  end

  def call
    validate_file!
    process_import
    success(@import)
  rescue ImportError => e
    @import.update!(status: :failed, error_message: e.message, finished_at: Time.current)
    failure(e.message)
  rescue => e
    Rails.logger.error("ImportService error: #{e.class} - #{e.message}\n#{e.backtrace.first(5).join("\n")}")
    @import.update!(status: :failed, error_message: "Erro interno durante a importação", finished_at: Time.current)
    failure("Erro interno durante a importação")
  end

  private

  attr_reader :import

  def validate_file!
    unless import.file.attached?
      raise ImportError, "Nenhum arquivo anexado"
    end

    ext = File.extname(import.filename).delete(".").downcase
    unless ALLOWED_EXTENSIONS.include?(ext)
      raise ImportError, "Formato de arquivo inválido. Use CSV, XLSX ou XLS."
    end
  end

  def process_import
    import.update!(status: :processing, started_at: Time.current)

    rows = parse_file
    import.update!(total_rows: rows.length)

    revenue_ranges = RevenueRange.all.index_by { |rr| normalize(rr.name) }
    sdrs = User.active_sdrs.to_a
    errors_detail = []
    imported_leads = []

    rows.each_with_index do |row, idx|
      row_num = idx + 2
      result = process_row(row, revenue_ranges, row_num)

      if result[:lead]
        imported_leads << result[:lead]
        import.increment!(:imported_rows)
      elsif result[:skipped]
        import.increment!(:skipped_rows)
      else
        errors_detail << result[:error]
        import.increment!(:failed_rows)
      end

      import.increment!(:processed_rows)
    end

    if imported_leads.any? && sdrs.any?
      LeadDistributionService.call(leads: imported_leads, sdrs: sdrs)
    end

    import.update!(
      status: :completed,
      finished_at: Time.current,
      errors_detail: errors_detail
    )

    AuditLogService.log(
      action: :lead_imported,
      user: import.user,
      auditable: import,
      metadata: {
        filename: import.filename,
        imported: import.imported_rows,
        skipped: import.skipped_rows,
        failed: import.failed_rows
      }
    )
  end

  def parse_file
    file_path = ActiveStorage::Blob.service.path_for(import.file.key)
    ext = File.extname(import.filename).delete(".").downcase

    spreadsheet = if ext == "csv"
      Roo::CSV.new(file_path)
    else
      Roo::Spreadsheet.open(file_path)
    end

    headers = spreadsheet.row(1).map { |h| normalize(h.to_s) }
    rows = []

    (2..spreadsheet.last_row).each do |i|
      raw = spreadsheet.row(i)
      rows << headers.zip(raw).to_h
    end

    rows
  rescue => e
    raise ImportError, "Não foi possível ler o arquivo: #{e.message}"
  end

  def process_row(row, revenue_ranges, row_num)
    mapped = map_columns(row)

    company = mapped[:company_name].to_s.strip
    return { skipped: true } if company.blank?

    phone = normalize_phone(mapped[:phone])
    email = mapped[:email].to_s.strip.downcase.presence

    existing = find_duplicate(phone, email)
    return { skipped: true } if existing

    revenue_range = resolve_revenue_range(mapped[:revenue_range], revenue_ranges)

    lead = Lead.new(
      company_name: company,
      contact_name: mapped[:contact_name].to_s.strip.presence,
      phone: phone,
      email: email,
      city: mapped[:city].to_s.strip.presence,
      state: mapped[:state].to_s.strip.upcase.presence,
      revenue_range: revenue_range,
      import: import,
      status: :sem_contato
    )

    if lead.save
      { lead: lead }
    else
      { error: { row: row_num, errors: lead.errors.full_messages } }
    end
  end

  def map_columns(row)
    result = {}
    row.each do |key, value|
      mapped_key = COLUMN_MAP[normalize(key.to_s)]
      result[mapped_key] = value if mapped_key
    end
    result
  end

  def find_duplicate(phone, email)
    return nil if phone.blank? && email.blank?

    query = Lead.none
    query = query.or(Lead.where(phone: phone)) if phone.present?
    query = query.or(Lead.where(email: email)) if email.present?
    query.exists?
  end

  def resolve_revenue_range(raw, revenue_ranges)
    return nil if raw.blank?
    revenue_ranges[normalize(raw.to_s)]
  end

  def normalize_phone(raw)
    return nil if raw.blank?
    raw.to_s.gsub(/\D/, "").presence
  end

  def normalize(str)
    str.to_s.strip.downcase.gsub(/\s+/, "_")
  end
end

class ImportError < StandardError; end
