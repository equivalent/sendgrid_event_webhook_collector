class Event < ActiveRecord::Base
  generate_public_uid

  scope :unprocessed, -> { where(processed_at: nil) }
  scope :processed, -> { where.not(processed_at: nil) }

  has_many :arguments, dependent: :destroy
  has_many :categories

  def self.process(logger= API.logger)
    whitelist = WhitelistArgument.pluck(:name)
    unprocessed.each do |event|
      logger.info "Proccessing #{event.to_logger_string}"
      EventProcessor.new
        .tap do |ep|
          ep.event = event
          ep.raw = event.raw
          ep.custom_whitelist = whitelist
        end
        .call
    end
  end

  def to_logger_string
    "Event #{id}"
  end

  def preview
    attributes.slice('name', 'email')
  end
end
