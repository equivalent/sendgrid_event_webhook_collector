class EventsQuery
  attr_reader :scope

  def initialize(scope)
    @scope = scope
  end

  def search(criteria)
    if criteria.empty?
      scope
    else
      criteria_query_search(criteria)
    end
  end

  private

  # criteria_query_search returns a scope
  # filtering only events matchin args
  #
  # to suport as many DB as possible the method
  # is triggering multiple SQL calls
  #
  # You can monky Patch this method to
  # trigger only singe SQL call using cuntom
  # SQL functions (In some DB)
  def criteria_query_search(criteria)
    event_ids = []
    criteria.each do |key, value|
      if event_ids.empty?
        event_ids = event_ids_with_argument(key, value)
      else
        event_ids &= event_ids_with_argument(key, value)
      end
    end
    scope.where(id: event_ids.uniq)
  end

  def event_ids_with_argument(key, value)
    if key == 'category'
      Category
        .where(value: value)
        .pluck(:event_id)
    else
      Argument
        .where(Argument.arel_table[:name].eq key)
        .where(Argument.arel_table[:value].eq value)
        .pluck(:event_id)
    end
  end
end
