require 'sinatra'
require 'grape'
require 'sinatra/activerecord'
require 'public_uid'
Dir['./lib/*.rb'].each {|file| require file }
require 'pry' if %w(test development).include?(ENV['RACK_ENV'])

register Sinatra::ActiveRecordExtension

class API < Grape::API
  content_type :json, 'application/json'
  default_format :json
  format :json

  #helpers do
    #def logger
      #API.logger
    #end
  #end

  get '/status' do
    { status: 'ok' }
  end

  resource :events do
    get do
      EventsSerializer.new(Event.all, params).to_hash
    end

    route_param :id do
      get do
        event = Event.find_by!(public_uid: params[:id])
        EventSerializer.new(event).to_hash
      end
    end
  end

  post '/sendgrid/event' do
    # due to rack beeing stupid and requiring hash only
    # syntax in params this is the only way how to get
    # the Array JSON provided by Sendgrid POST body
    raw_events = JSON.parse(request.body.read)

    raw_events.collect do |event_params|
      Event.create!(raw: event_params).id
    end
  end
end

class Web < Sinatra::Base
  get '/' do
    "Hello world."
  end
end
