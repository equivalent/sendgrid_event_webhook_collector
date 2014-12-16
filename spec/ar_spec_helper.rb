require 'spec_helper.rb'
require 'database_cleaner'

ActiveRecord::Base.logger = NullLogger.new # silence SQL outpupt in log

RSpec.configure do |config|
  config.before :suite do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before :each do
    DatabaseCleaner.clean_with :deletion
  end
end
