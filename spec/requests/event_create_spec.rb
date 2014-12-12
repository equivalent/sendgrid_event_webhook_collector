require 'spec_helper'

RSpec.describe 'POST /v1/request.ipevents' do
  include Rack::Test::Methods

  Given!(:token) { create(:user, :creator).token }

  Given!(:init_event_count) { Event.count }

  Given(:sendgrid_json) do
    JSONFixture
      .new('sendgrid_multiple_events.json')
      .to_json
  end

  When 'sendgrid sends event to our app' do
    post("/v1/events?token=#{token}", sendgrid_json)
  end

  Then do
    expect(last_response.status).to eq(201)
  end

  Then do
    expect(json_response).to eq(Event.pluck(:id).last(7))
  end

  Then do
    expect(Event.count)
      .to eq(init_event_count + 7)

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

  context 'not passing token any way' do
    When do
      post("/v1/events")
    end

    Then do
      expect(last_response.status).to be 401
    end
  end

  context 'passing token of user withotu creator permission' do
    Given!(:token) { create(:user).token }

    When do
      post("/v1/events?token=#{token}", sendgrid_json)
    end

    Then do
      expect(last_response.status).to be 403
    end
  end
end
