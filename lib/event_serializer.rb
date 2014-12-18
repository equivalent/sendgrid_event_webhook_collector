require 'awrence'
class EventSerializer
  attr_reader :resource
  attr_accessor :authority

  def initialize(resource)
    @resource = resource
  end

  def attributes
    [:occurred_at]
  end

  def to_hash
    resource
      .attributes
      .slice(*attributes.collect(&:to_s))
      .merge({
        'href' => href,
        'id' => resource.public_uid,
        'categories' => categories
      })
      .merge(event_based_arguments)
      .tap do |hash|
        hash.update(hash) { |key, v| value_to_s(v) }
      end
      .to_camelback_keys
      .sort
      .to_h
  end

  def arguments
    @arguments ||= resource.arguments
  end

  def event_based_arguments
    arguments
      .select { |a| a.event_based? }
      .inject({}) do |hash, argument|
        hash[argument.name] = argument.value
        hash
      end
  end

  def categories
    arguments
      .select { |a| a.category_based? }
      .collect(&:value)
      .sort
  end

  def value_to_s(value)
    case value
    when Time
      value.utc.iso8601
    when Hash
      value.update(value) do |key, v|
        value_to_s(v)
      end
    when Array
      value.collect { |v| value_to_s(v) }
    else
      value
    end
  end

  def href
    "#{authority}/v1/events/#{resource.public_uid}"
  end
end
