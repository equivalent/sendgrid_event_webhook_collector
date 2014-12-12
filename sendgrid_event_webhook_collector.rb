require 'sinatra'
require 'grape'
require 'sinatra/activerecord'
require 'public_uid'
Dir['./lib/helpers/*.rb'].each {|file| require file }
Dir['./lib/*.rb'].each {|file| require file }
require 'pry' if %w(test development).include?(ENV['RACK_ENV'])

register Sinatra::ActiveRecordExtension

class API < Grape::API
  content_type :json, 'application/json'
  default_format :json
  format :json

  helpers CurrentUserHelpers
  helpers do
    def logger
      API.logger
    end
  end

  get '/status' do
    { status: 'ok' }
  end

  resource :events do
    get do
      logger.info('Accessing /events')

      auth.authenticate!
      auth.policy = EventPolicy
      auth.action = :index?
      auth.authorize!

      permitted_events = EventPolicy::Scope
        .new(current_user, Event.all)
        .resolve

      EventsSerializer.new(permitted_events, params).to_hash
    end

    post do
      auth.authenticate!
      auth.policy = EventPolicy
      auth.action = :create?
      auth.authorize!

      raw_events = JSON.parse(request.body.read)

      raw_events.collect do |event_params|
        Event.create!(raw: event_params).id
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

        EventSerializer.new(event).to_hash
      end
    end
  end
end

class Web < Sinatra::Base
  get '/' do
    "Hello world."
  end
end
