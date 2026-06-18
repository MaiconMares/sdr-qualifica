class AdminKanbanPolicy < ApplicationPolicy
  def show? = admin?
  def move? = admin?
end
