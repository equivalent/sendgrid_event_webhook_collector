require 'securerandom'
class User < ActiveRecord::Base
  TOKEN_SIZE=20

  before_create :generate_token

  validates :name, presence: true
  validates :application_name, presence: true

  generate_public_uid

  def generate_token
    self.token = SecureRandom.hex(TOKEN_SIZE)
  end
end
