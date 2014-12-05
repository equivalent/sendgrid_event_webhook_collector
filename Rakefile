require "sinatra/activerecord/rake"
require './sendgrid_event_webhook_collector'

if %w(test development).include?(ENV['RACK_ENV'])
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
  task :default => :spec
end
