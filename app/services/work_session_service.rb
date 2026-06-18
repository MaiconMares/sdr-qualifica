class WorkSessionService < ApplicationService
  def initialize(user:, request: nil)
    @user = user
    @request = request
  end

  def call
    ensure_single_active_session
    success(@user.current_work_session)
  end

  def self.start(user:, request: nil)
    new(user: user, request: request).start
  end

  def self.end_session(user:, request: nil)
    new(user: user, request: request).end_session
  end

  def start
    return success(existing) if (existing = user.current_work_session)
    return failure("Sem leads pendentes para iniciar sessão") unless user.pending_leads_count > 0

    session = WorkSession.create!(
      user: user,
      started_at: Time.current,
      status: :active
    )

    AuditLogService.log(
      action: :work_session_start,
      user: user,
      auditable: session,
      request: request
    )

    success(session)
  end

  def end_session
    session = user.current_work_session
    return failure("Nenhuma sessão ativa") unless session

    ActiveRecord::Base.transaction do
      if session.paused?
        active_pause = user.active_pause
        active_pause&.end!
        session.resume!(active_pause) if active_pause
      end

      session.complete!

      AuditLogService.log(
        action: :work_session_end,
        user: user,
        auditable: session,
        request: request
      )
    end

    success(session)
  end

  private

  attr_reader :user, :request

  def ensure_single_active_session
    user.work_sessions
        .where(status: [ :active, :paused ])
        .order(started_at: :asc)
        .offset(1)
        .destroy_all
  end
end
