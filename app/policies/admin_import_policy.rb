class AdminImportPolicy < ApplicationPolicy
  def index? = admin?
end
