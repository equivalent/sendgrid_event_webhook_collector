class EventPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
        .joins(:categories)
        .where(Category.arel_table[:value].eq user.application_name)
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
    record.categories.collect(&:value).include? user.application_name
  end

  def create?
    user.creator
  end
end
