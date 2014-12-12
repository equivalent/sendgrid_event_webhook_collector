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
    User.all.collect do |u|
      [u.name, u.application_name, u.token, u.creator ? 'creator' : nil ]
    end.tap { |row| puts "#{row.join(' | ')}"}
  end

  desc 'create new user setup'
  task :add do
    user = User.new

    puts "Name of user"
    user.name = STDIN.gets().strip

    if yes_no("Is this an User that can create Sendgrid events ?")
      user.creator = true
    end

    puts "Application name that user can access"
    name = STDIN.gets.strip
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
      puts "token: #{user.token}"
    else
      puts 'User creation cancled'
    end
  end
end

def yes_no(question)
  begin
    puts "#{question} ?  (yes/no) "
  end while (!%w(yes no).include?(answer = STDIN.gets.strip))
  answer == 'yes'
end
