class AuditLogPolicy < ApplicationPolicy
  def index? = admin?
  def show?  = admin?

  class Scope < ApplicationPolicy::Scope
    def resolve
      admin? ? scope.all : scope.none
    end
  end
end
