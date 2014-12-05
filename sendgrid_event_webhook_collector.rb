require 'sinatra'
require 'grape'
require "sinatra/activerecord"
require './lib/app_path'
require 'pry' if ENV['RACK_ENV'] == 'test'

register Sinatra::ActiveRecordExtension

class API < Grape::API
  post 'sendgrid/event' do
    {}
  end
end

class Web < Sinatra::Base
  get '/' do
    "Hello world."
  end
end
