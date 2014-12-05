require 'pathname'
require 'rack/test'
require 'rspec'
require 'rspec/given'
require './sendgrid_event_webhook_collector'
require 'json'

ENV['RACK_ENV'] = 'test'

class App
  module Test
    def self.fixture
      App.root.join('spec', 'fixtures')
    end
  end

  def self.root
    Pathname.new(File.dirname __dir__)
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
