class UserPolicy < ApplicationPolicy
  def index?  = admin?
  def show?   = admin?
  def create? = admin?
  def update? = admin?
  def destroy? = admin?

  def activate?   = admin?
  def deactivate? = admin?

  class Scope < ApplicationPolicy::Scope
    def resolve
      admin? ? scope.all : scope.where(id: user.id)
    end
  end
end
