class EventsSerializer
  attr_reader :scope, :params
  attr_accessor :authority

  def initialize(scope, params)
    @scope  = scope
    @params = params
  end

  def href(offset: 0)
    link = "#{authority}/v1/events?offset=#{offset}&limit=#{limit}"
    link += '&expand=items' if expand?('items')
    link
  end

  def next?
    !resources.map(&:id).include?(search_scope.last.id) if resources.any?
  end

  def previous?
    offset > 0
  end

  def to_hash
    {
      href: href(offset: offset),
      offset: offset,
      limit: limit,
      first: href(offset: 0),
      next: next? ? href(offset: offset + 1) : '',
      previous: previous? ? href(offset: offset - 1) : '',
      last: "",
      items: items
    }
  end

  private

  def items
    resources.collect { |event| serialize_resource(event) }
  end

  def resources
    search_scope
      .limit(limit)
      .offset(offset)
  end

  def serialize_resource(event)
    hash = EventSerializer
      .new(event)
      .tap { |es| es.authority = authority }
      .to_hash

    hash.slice!('id', 'href') unless expand?('items')
    hash
  end

  def search_scope
    EventsQuery
      .new(scope)
      .search(params['q'] || {})
  end

  def expand?(what)
    params[:expand] == what
  end

  def offset
    params[:offset] && params[:offset].to_i || 0
  end

  def limit
    params[:limit] && params[:limit].to_i || 40
  end
end
