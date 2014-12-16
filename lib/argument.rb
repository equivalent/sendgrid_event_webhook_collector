class Argument < ActiveRecord::Base
  belongs_to :event
  validates :name,  presence: true
  validates :value, presence: true
end
