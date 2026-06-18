class PauseService < ApplicationService
  def initialize(user:, reason:, description: nil, request: nil)
    @user = user
    @reason = reason
    @description = description
    @request = request
  end

  def call
    return failure("Nenhuma sessão de trabalho ativa") unless work_session
    return failure("Sessão já está pausada") if work_session.paused?

    pause = nil
    ActiveRecord::Base.transaction do
      pause = Pause.create!(
        user: user,
        work_session: work_session,
        reason: reason,
        description: description,
        started_at: Time.current
      )
      work_session.pause!(pause)

      AuditLogService.log(
        action: :pause_started,
        user: user,
        auditable: pause,
        metadata: { reason: reason },
        request: request
      )
    end

    success(pause)
  end

  private

  attr_reader :user, :reason, :description, :request

  def work_session
    @work_session ||= user.current_work_session
  end
end
