source 'https://rubygems.org'

ruby '2.1.4'

# core
gem 'rake'
gem 'sinatra'
gem 'grape'

# server
gem 'unicorn'

# db
gem 'pg'
gem 'sinatra-activerecord'

# JSONizing keys
gem 'awrence' # underscore to camelCase
#gem 'plissken' # camelCase to underscore

# Uri
gem 'public_uid'

group  :test, :development do
  gem 'therubyracer', platforms: :ruby # Ubuntu fix
  gem 'pry'
  gem 'rspec-given'
  gem 'database_cleaner'
  gem 'factory_girl'
  gem 'rack-test'
end
