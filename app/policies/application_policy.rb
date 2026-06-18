class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?   = admin?
  def show?    = admin?
  def create?  = admin?
  def new?     = create?
  def update?  = admin?
  def edit?    = update?
  def destroy? = admin?

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NoMethodError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope

    def admin?
      user.admin?
    end
  end

  private

  def admin?
    user&.admin?
  end

  def sdr?
    user&.sdr?
  end
end
