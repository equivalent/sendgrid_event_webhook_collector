require 'ar_spec_helper'

RSpec.describe 'GET /v1/events' do
  include Rack::Test::Methods

  Given!(:token) { create(:user).token }

  context 'authorization' do
    Given!(:events) do
      [
        create(:event, :processed),
        create(:event, :processed),
      ]
    end

    Given!(:unprocessed_event) { create(:event) }
    Given!(:other_user_event) do
      create(:event, :processed, category_values: ['asking', 'alexandria'])
    end

    context 'using params token' do
      When { get("/v1/events?token=#{token}") }

      Then do
        expect(last_response.status).to be 200
      end

      Then do
        expect(json_response).to be_kind_of Hash
        expect(json_response.fetch('items'))
          .to match events.collect { |e| { 'href' => event_url(e.public_uid),
                                           'id' => e.public_uid } }
      end
    end

    context 'using Authorization token' do
      When do
        header('Authorization', "Token #{token}")
        get("/v1/events")
      end

      Then do
        expect(last_response.status).to be 200
      end
    end

    context 'not passing token any way' do
      When do
        get("/v1/events")
      end

      Then do
        expect(last_response.status).to be 401
      end
    end
  end

  context 'when quering by name' do
    Given!(:event) do
      create(:event, :processed).tap do |event|
        event.arguments << build(:custom_argument, name: 'tagMy2', value: 'abc')
      end
    end

    Given(:events_json_event_hrefs) { json_response.fetch('items').collect{ |h| h.fetch('href') } }

    When do
      header('Authorization', "Token #{token}")
      get("/v1/events?q[tagMy2]=abc")
    end

    Then do
      expect(events_json_event_hrefs).to include event_url(event.public_uid)
    end
  end

  context 'when events are empty' do
    When do
      header('Authorization', "Token #{token}")
      get("/v1/events")
    end

    Then do
      expect(json_response).to eq({
        "first" => "http://api.myapp.com/v1/events?offset=0&limit=40",
        "href" => "http://api.myapp.com/v1/events?offset=0&limit=40",
        "items" => [],
        "last" => "",
        "limit" => 40,
        "next" => "",
        "offset" => 0,
        "previous" => "",
      })
    end
  end
end
