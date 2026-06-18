class RevenueRangePolicy < ApplicationPolicy
  def index?  = admin?
  def show?   = admin?
  def create? = admin?
  def update? = admin?

  class Scope < ApplicationPolicy::Scope
    def resolve
      admin? ? scope.all : scope.none
    end
  end
end
