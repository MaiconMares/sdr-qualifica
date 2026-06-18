class ImportJob < ApplicationJob
  queue_as :imports

  retry_on StandardError, wait: :polynomially_longer, attempts: 3

  def perform(import_id)
    import = Import.find(import_id)
    result = ImportService.call(import: import)
    broadcast_status(import)
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error("ImportJob: Import #{import_id} not found — #{e.message}")
  end

  private

  def broadcast_status(import)
    Turbo::StreamsChannel.broadcast_replace_to(
      "import_#{import.id}",
      target: "import_status_#{import.id}",
      partial: "admin/imports/status",
      locals: { import: import.reload }
    )

    Turbo::StreamsChannel.broadcast_replace_to(
      "imports_list",
      target: "import_row_#{import.id}",
      partial: "admin/imports/import_row",
      locals: { import: import }
    )
  rescue => e
    Rails.logger.error("ImportJob broadcast failed: #{e.message}")
  end
end
