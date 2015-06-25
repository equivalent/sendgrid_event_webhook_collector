source 'https://rubygems.org'

ruby '2.2.2'

# core
gem 'rake'
gem 'sinatra'
gem 'grape'
gem 'foreman' # run Procfile

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

# console output
gem 'table_print'

group  :test, :development do
  gem 'therubyracer', platforms: :ruby # Ubuntu fix
  gem 'pry'
  gem 'rspec-given'
  gem 'database_cleaner'
  gem 'factory_girl'
  gem 'rack-test'
end
