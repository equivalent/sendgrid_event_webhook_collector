class WhitelistArgument < ActiveRecord::Base
  validates :name,  presence: true

  def self.custom_keys
    pluck(:name)
  end

end
