class KanbanPolicy < ApplicationPolicy
  def show? = admin?
  def move? = admin?
end
