require 'sinatra'
require 'grape'
require 'sinatra/activerecord'
require 'public_uid'
require 'pry' if %w(test development).include?(ENV['RACK_ENV'])
Dir['./lib/helpers/*.rb'].each {|file| require file }
Dir['./models/*.rb'].each {|file| require file }
Dir['./lib/*.rb'].each {|file| require file }

register Sinatra::ActiveRecordExtension

class API < Grape::API
  content_type :json, 'application/json'
  default_format :json
  format :json
  version 'v1', using: :path

  helpers CurrentUserHelpers
  helpers do
    def logger
      API.logger
    end

    def authority
      "#{env["rack.url_scheme"]}://#{request.host_with_port}"
    end
  end

  before do
    logger.info "#{request.ip} #{request.request_method} " +
                "#{env['PATH_INFO']} " +
                "Token: #{token || 'NONE'}"
  end

  get '/status' do
    { status: 'ok' }
  end

  resource :events do
    get do
      auth.authenticate!
      auth.policy = EventPolicy
      auth.action = :index?
      auth.authorize!

      permitted_events = EventPolicy::Scope
        .new(current_user, Event.processed)
        .resolve

      EventsSerializer
        .new(permitted_events, params)
        .tap { |es| es.authority = authority }
        .to_hash
    end

    post do
      auth.authenticate!
      auth.policy = EventPolicy
      auth.action = :create?
      auth.authorize!

      raw_events = JSON.parse(request.body.read)

      raw_events.collect do |event_params|
        Event
          .create!(raw: event_params)
          .public_uid
      end
    end

    route_param :public_uid do
      get do
        auth.authenticate!
        event = Event.find_by!(public_uid: params[:public_uid])

        auth.authenticate!
        auth.policy = EventPolicy
        auth.action = :show?
        auth.resource = event
        auth.authorize!

        EventSerializer
          .new(event)
          .tap { |es| es.authority = authority }
          .to_hash
      end
    end
  end
end

class Web < Sinatra::Base
  get '/' do
    "Hello world."
  end
end

logger = Logger.new(ENV['logger_path'] ||= 'tmp/sewc.log')
logger.level = 1 # info
API.logger = logger
ActiveRecord::Base.logger = logger

