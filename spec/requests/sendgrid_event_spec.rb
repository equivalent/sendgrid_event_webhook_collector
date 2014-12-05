require 'spec_helper'

describe 'POST /sendgrid/event' do

  When 'sendgrid sends event to our app' do
    json = File.read(App::Test.fixture.join('sendgrid_event.json'))
    post("sendgrid/event", params: json)
  end

  Then do
    expect(last_response.status).to eq(201)
  end

  Then do
    expect(JSON.parse(last_response.body)).to eq({})
  end
end
