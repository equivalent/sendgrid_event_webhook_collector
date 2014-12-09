class User
  attr_accessor :token
  attr_accessor :name
  attr_accessor :application_names

  def application_names
    ['validations_production']
  end
end
