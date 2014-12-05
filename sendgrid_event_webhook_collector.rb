require 'sinatra'
require 'grape'
require 'pry'

class API < Grape::API
  post 'sendgrid/event' do
    puts "AAAAAAAAAAAAAAA"
    { hello: "world" }
  end
end

class Web < Sinatra::Base
  get '/' do
    "Hello world."
  end
end
