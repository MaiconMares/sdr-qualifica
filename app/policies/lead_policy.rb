class LeadPolicy < ApplicationPolicy
  def index?  = admin?
  def show?   = admin? || assigned_to_sdr?
  def update? = admin?
  def destroy? = admin?

  def kanban? = admin?
  def redistribute? = admin?

  class Scope < ApplicationPolicy::Scope
    def resolve
      if admin?
        scope.all
      else
        scope.assigned_to(user)
      end
    end
  end

  private

  def assigned_to_sdr?
    sdr? && record.assigned_users.include?(user)
  end
end
