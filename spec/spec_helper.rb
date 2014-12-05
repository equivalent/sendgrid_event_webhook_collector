ENV['RACK_ENV'] = 'test'

require 'rack/test'
require 'rspec'
require 'rspec/given'
require './sendgrid_event_webhook_collector'
require 'json'

class AppPath
  module Test
    def self.fixture
      AppPath.root.join('spec', 'fixtures')
    end
  end
end

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
end

def app
  API
end
