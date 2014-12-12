require 'awrence'
class EventSerializer
  attr_reader :resource
  attr_accessor :authority

  def initialize(resource)
    @resource = resource
  end

  def attributes
    [:name, :email, :occurred_at, :categories]
  end

  def to_hash
    resource
      .attributes
      .slice(*attributes.collect(&:to_s))
      .merge({
        'href' => href,
        'sendgrid' => sendgrid,
        'id' => resource.public_uid,
      })
      .tap do |hash|
        hash.update(hash) { |key, v| value_to_s(v) }
      end
      .to_camelback_keys
      .sort
      .to_h
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

  def sendgrid
    resource.raw
  end
end
