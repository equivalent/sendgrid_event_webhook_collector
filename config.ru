require './sendgrid_event_webhook_collector'
#use Rack::Session::Cookie
run Rack::Cascade.new [API, Web]
