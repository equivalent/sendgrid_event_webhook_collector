class EventProcessor
  ArgumentNotProvidedBySendgrid = Class.new(StandardError)

  attr_accessor :event
  attr_accessor :raw
  attr_accessor :custom_whitelist

  def self.argument_name_map(name)
    case name
    when 'event'
      'name'
    else
      name
    end
  end

  def call
    event.occurred_at = Time.at(raw.fetch('timestamp').to_i)

    add_sendgrid_arguments
    add_custom_arguments
    add_category_arguments

    event.processed_at = Time.now
    event.save
  end

  private
  def add_custom_arguments
    custom_whitelist.each do |arg_name|
      begin
        event.arguments << CustomArgument.new do |a|
          a.name  = arg_name
          a.value = raw.fetch(arg_name) do
            raise ArgumentNotProvidedBySendgrid
          end
        end
      rescue ArgumentNotProvidedBySendgrid
        # don't add
      end
    end
  end

  def add_sendgrid_arguments
    sendgrid_hardcoded_whitelist.each do |arg_name|
      begin
        event.arguments << SendgridArgument.new do |a|
          a.name  = self.class.argument_name_map(arg_name)
          a.value = raw.fetch(arg_name) do
            raise ArgumentNotProvidedBySendgrid
          end
        end
      rescue ArgumentNotProvidedBySendgrid
        # don't add
      end
    end
  end

  def add_category_arguments
    raw.fetch('category').each do |category_name|
      event.arguments << Category
        .new { |ca| ca.value = category_name }
    end
  end

  def sendgrid_hardcoded_whitelist
    %w(email event)
  end
end
