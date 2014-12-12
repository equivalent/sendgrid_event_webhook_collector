require "sinatra/activerecord/rake"
require './sendgrid_event_webhook_collector'

if %w(test development).include?(ENV['RACK_ENV'])
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
  task :default => :spec
end

namespace :user do
  desc "list users"
  task :list do
    User.pluck(:name, :application_name, :token).each do |attributes|
      puts attributes.join(' | ')
    end
  end

  desc 'create new user setup'
  task :add do
    user = User.new


    puts "Is this a Sendgrid access user ?"

    puts "Name of user"
    user.name = STDIN.gets().strip

    puts "Application name that user can access"
    user.application_name = STDIN.gets.strip

    accessable_events = EventPolicy::Scope
      .new(user, Event.all)
      .resolve

    puts "User will be able to access #{accessable_events.count} Events"
    accessable_events.processed.limit(3).order('id DESC').each do |event|
      puts event.preview
    end

    begin
      puts %Q{Save user "#{user.name}" ?  yes/no }
    end while (!%w(yes no).include?(save = STDIN.gets.strip))

    if save == 'yes'
      user.save!
      puts "token: #{user.token}"
    else
      puts 'User creation cancled'
    end
  end
end


