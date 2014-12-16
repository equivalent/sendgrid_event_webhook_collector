class EventProcessor
  ArgumentNotProvidedBySendgrid = Class.new(StandardError)

  attr_accessor :event
  attr_accessor :raw
  attr_accessor :whitelist

  def call
    event.name = raw.fetch('event')
    event.email = raw.fetch('email')
    event.occurred_at = Time.at(raw.fetch('timestamp').to_i)
    event.categories = raw.fetch('category')
    event.processed_at = Time.now

    add_args_to_event

    event.save
  end

  private
  def add_args_to_event
    whitelist.each do |arg_name|
      begin
        event.arguments << Argument.new do |a|
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
end
