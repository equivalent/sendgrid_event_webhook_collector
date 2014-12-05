require 'sinatra'
require 'grape'
require "sinatra/activerecord"
require './lib/app_path'
require './lib/event'
require 'pry' if %w(test development).include?(ENV['RACK_ENV'])

register Sinatra::ActiveRecordExtension

class API < Grape::API
  content_type :json, 'application/json'
  default_format :json
  format :json

  helpers do
    def logger
      API.logger
    end
  end

  get '/status' do
    { status: 'ok' }
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
