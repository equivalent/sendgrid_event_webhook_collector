ENV['RACK_ENV'] = 'test'
ENV['logger_path'] = 'tmp/sewc-test.log'

require 'rack/test'
require 'json'
require 'rspec'
require 'rspec/given'
require 'factory_girl'
require './sendgrid_event_webhook_collector'

ActiveRecord::Base.logger = Logger.new(STDOUT)

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

module Rack
  module Test
    module Methods
      def build_rack_mock_session
        Rack::MockSession.new(app, 'api.myapp.com')
      end
    end
  end
end

API.logger = NullLogger.new
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
  config.include FactoryGirl::Syntax::Methods
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
