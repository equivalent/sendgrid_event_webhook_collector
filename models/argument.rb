class Argument < ActiveRecord::Base
  belongs_to :event
  validates :value, presence: true

  def event_based?
    %w(CustomArgument SendgridArgument).include? type
  end

  def category_based?
    type == 'Category'
  end
end

class CustomArgument < Argument
  validates :name,  presence: true
end

class Category < Argument
end

class SendgridArgument < Argument
  validates :name,  presence: true
end

