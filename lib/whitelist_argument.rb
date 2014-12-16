class WhitelistArgument < ActiveRecord::Base
  validates :name,  presence: true
end
