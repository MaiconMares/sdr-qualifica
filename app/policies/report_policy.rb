class ReportPolicy < ApplicationPolicy
  def show? = admin?
  def export? = admin?
end
