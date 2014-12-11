class EventPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      # PostgreSQL only sofar
      scope.where("? = ANY(events.categories)", user.application_name)
    end
  end

  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true
  end

  def show?
    record.categories.include?(user.application_name)
  end
end
