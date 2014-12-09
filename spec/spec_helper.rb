ENV['RACK_ENV'] = 'test'

require 'rack/test'
require 'json'
require 'rspec'
require 'rspec/given'
require 'database_cleaner'
require 'factory_girl'
require './sendgrid_event_webhook_collector'

class AppPath
  module Test
    def self.fixture
      AppPath.root.join('spec', 'fixtures')
    end

    def self.support
      AppPath.root.join('spec', 'support')
    end
  end
end

require AppPath::Test.support.join('json_fixture')
require AppPath::Test.support.join('null_logger')

# silence SQL outpupt in log
ActiveRecord::Base.logger = NullLogger.new
FactoryGirl.find_definitions

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  #config.warnings = true
  config.order = :random # Run specs in random order
  config.include Rack::Test::Methods
  config.include FactoryGirl::Syntax::Methods

  config.before :suite do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before :each do
    DatabaseCleaner.clean_with :deletion
  end
end

def app
  API
end

def json_response
  begin
    JSON.parse(last_response.body)
  rescue JSON::ParserError
    raise "response body should be JSON but it's not"
  end
end

def event_url(uid)
  "http://api.myapp.com/v1/events/#{uid}"
end
