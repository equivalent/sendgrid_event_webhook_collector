require 'sinatra'
require 'grape'
require 'pry'

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
