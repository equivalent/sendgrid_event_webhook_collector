$stdout.sync = true # this will ensure that log is in sync
                    # if you use heroku

require 'rack/ssl-enforcer'
use Rack::SslEnforcer

require './sendgrid_event_webhook_collector'
#use Rack::Session::Cookie
run Rack::Cascade.new [API, Web]
