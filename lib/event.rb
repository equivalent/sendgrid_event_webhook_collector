class Event < ActiveRecord::Base
  generate_public_uid

  scope :unprocessed, -> { where(processed_at: nil) }
  scope :processed, -> { where.not(processed_at: nil) }

  def self.process
    unprocessed.each(&:process)
  end

  def process
    self.name = raw.fetch('event')
    self.email = raw.fetch('email')
    self.occurred_at = Time.at(raw.fetch('timestamp').to_i)
    self.categories = raw.fetch('category') { [] }
    self.processed_at = Time.now
    self.save
  end

  def preview
    attributes.slice('name', 'email', 'occurred_at')
  end
end
