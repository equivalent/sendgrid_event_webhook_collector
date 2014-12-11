require 'spec_helper'

RSpec.describe 'POST /sendgrid/event' do
  include Rack::Test::Methods

  Given 'valid Sendgrid JSON' do
    @init_event_count = Event.count
    @json = JSONFixture.new('sendgrid_multiple_events.json').to_json
  end

  When 'sendgrid sends event to our app' do
    post("sendgrid/event", @json)
  end

  Then do
    expect(last_response.status).to eq(201)
  end

  Then do
    expect(json_response).to eq(Event.pluck(:id).last(7))
  end

  Then do
    expect(Event.count)
      .to eq(@init_event_count + 7)

    expect(Event.last.raw).to match(
      {
        "email"=>"john.doe@gmail.com",
        "timestamp"=>1386638248,
        "uid"=>"123456",
        "purchase"=>"PO1452297845",
        "id"=>"001",
        "category"=>["category1", "category2", "category3"],
        "event"=>"unsubscribe"
      }
    )
  end
end
