class ResumeService < ApplicationService
  def initialize(user:, request: nil)
    @user = user
    @request = request
  end

  def call
    return failure("Nenhuma sessão de trabalho ativa") unless work_session
    return failure("Sessão não está pausada") unless work_session.paused?
    return failure("Nenhuma pausa ativa encontrada") unless active_pause

    ActiveRecord::Base.transaction do
      active_pause.end!
      work_session.resume!(active_pause)

      AuditLogService.log(
        action: :pause_ended,
        user: user,
        auditable: active_pause,
        metadata: { duration_seconds: active_pause.duration_seconds },
        request: request
      )
    end

    success(work_session)
  end

  private

  attr_reader :user, :request

  def work_session
    @work_session ||= user.current_work_session
  end

  def active_pause
    @active_pause ||= user.active_pause
  end
end
