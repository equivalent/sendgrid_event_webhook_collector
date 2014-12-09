class EventsSerializer
  attr_reader :scope, :params

  def initialize(scope, params)
    @scope  = scope
    @params = params
  end

  def href
    link = "http://api.myapp.com/v1/events?offset=#{offset}&limit=#{limit}"
    link += '&expand=items' if expand?('items')
    link
  end

  def to_hash
    {
      href: href,
      offset: offset,
      limit: limit,
      first: "",
      next: "",
      previous: "",
      last: "",
      items: items
    }
  end

  private

  def items
    scope
      .limit(limit)
      .offset(offset)
      .collect do |e|
        hash = EventSerializer
          .new(e)
          .to_hash

        hash.slice!('href') unless expand?('items')
        hash
      end
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
