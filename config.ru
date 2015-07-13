$stdout.sync = true # this will ensure that log is in sync
                    # if you use heroku

ENV['logger_path'] = '/var/log/sewc.log' if ENV['RACK_ENV'] == 'production'

unless ENV['RACK_ENV'] == 'development'
  require 'rack/ssl-enforcer'
  use Rack::SslEnforcer
end

require './sendgrid_event_webhook_collector'
#use Rack::Session::Cookie
run Rack::Cascade.new [API, Web]
