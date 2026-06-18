class KanbanMovementService < ApplicationService
  def initialize(lead:, new_status:, user:, request:)
    @lead = lead
    @new_status = new_status
    @user = user
    @request = request
  end

  def call
    return failure("Status inválido") unless valid_status?
    return failure("Status não pode ser alterado") unless can_change_status?

    previous_status = @lead.status

    @lead.transaction do
      @lead.update!(status: @new_status)
      
      LeadStatusHistory.create!(
        lead: @lead,
        previous_status: previous_status,
        new_status: @new_status,
        changed_by: @user,
        description: "Movido via Kanban"
      )
      
      AuditLogService.log(
        action: :status_changed,
        user: @user,
        auditable: @lead,
        request: @request,
        metadata: { previous_status: previous_status, new_status: @new_status }
      )
    end

    success
  rescue ActiveRecord::RecordInvalid => e
    failure(e.message)
  end

  private

  def valid_status?
    Lead.statuses.key?(@new_status.to_s)
  end

  def can_change_status?
    # Add any business rules for status transitions here
    true
  end
end
