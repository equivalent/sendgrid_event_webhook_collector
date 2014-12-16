class Event < ActiveRecord::Base
  generate_public_uid

  scope :unprocessed, -> { where(processed_at: nil) }
  scope :processed, -> { where.not(processed_at: nil) }

  has_many :arguments

  def self.process
    whitelist = WhitelistArgument.pluck(:name)
    unprocessed.each do |event|
      EventProcessor.new
        .tap do |ep|
          ep.event = event
          ep.raw = event.raw
          ep.whitelist = whitelist
        end
        .call
    end
  end

  def preview
    attributes.slice('name', 'email', 'occurred_at')
  end
end
