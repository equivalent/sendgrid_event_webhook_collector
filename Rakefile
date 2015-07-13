require "sinatra/activerecord/rake"
require './sendgrid_event_webhook_collector'
require 'table_print'
require 'rspec/core/rake_task'

logger = Logger.new('/var/log/sewc-rake.log')
logger.level = 1 # info
API.logger = logger
ActiveRecord::Base.logger = logger

if %w(test development).include?(ENV['RACK_ENV'])
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
  task :default => :spec
end

namespace :event do
  desc 'Process unprocessed Events'
  task :process do
    # make this cron http://www.eq8.eu/blogs/15-cron-rbenv-bundle-exec-rake-task
    API.logger.info 'Processing events'
    Event.process
  end
end

namespace :whitelist_argument do
  desc 'add new whitelist argument'
  task :add do
    wa = WhitelistArgument.new

    puts "Whitelist argument name"
    wa.name = input

    wa.save

    puts "Whitelist created"
  end

  desc 'list all whitelist arguments'
  task :list do
    tp WhitelistArgument.all
  end
end

namespace :user do
  desc "list users"
  task :list do
    tp User.all, 'id', 'name', 'creator', 'application_name'
  end

  desc 'create new user setup'
  task :add do
    user = User.new

    puts "Name of user"
    user.name = input

    if yes_no("Is this an User that can create Sendgrid events ?")
      user.creator = true
    end

    puts "Application name that user can access"
    name = input
    user.application_name = name == '' ? nil : name

    accessable_events = EventPolicy::Scope
      .new(user, Event.all)
      .resolve

    puts "User will be able to access #{accessable_events.count} Events"
    accessable_events.processed.limit(3).order('id DESC').each do |event|
      puts event.preview
    end

    if yes_no("Save user #{user.name}")
      user.save!
      puts "Token: #{user.token}"
      puts 'Please write down this token'
    else
      puts 'User creation cancled'
    end
  end
end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = Dir.glob('spec/**/*_spec.rb')
end

task default: [:spec]

def yes_no(question)
  begin
    puts "#{question} ?  (yes/no) "
  end while (!%w(yes no).include?(answer = input))
  answer == 'yes'
end

def input
  STDIN.gets.strip
end
