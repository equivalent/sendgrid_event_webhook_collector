require 'spec_helper'

describe 'POST /sendgrid/event' do
  Given 'valid Sendgrid JSON' do
    @init_event_count = Event.count
    @json = File.read(AppPath::Test.fixture.join('sendgrid_event.json'))
  end

  When 'sendgrid sends event to our app' do
    post("sendgrid/event", @json)
  end

  Then do
    expect(last_response.status).to eq(201)
  end

  Then do
    expect(json_response).to eq([Event.last.id])
  end

  Then do
    expect(Event.count)
      .to eq(@init_event_count + 1)

    expect(Event.last.raw.keys)
      .to include('email', 'timestamp', 'smtp-id', 'event')
  end
end
