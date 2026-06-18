class DialerPolicy < ApplicationPolicy
  def show?   = sdr?
  def update? = sdr?

  class Scope < ApplicationPolicy::Scope
    def resolve
      sdr? ? scope.assigned_to(user) : scope.none
    end
  end
end
