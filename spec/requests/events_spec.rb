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
      create(:event, :processed, categories: ['asking', 'alexandria'])
    end

    context 'using params token' do
      When { get("/v1/events?token=#{token}") }

      Then do
        expect(last_response.status).to be 200
      end

      Then do
        expect(json_response).to be_kind_of Hash
        expect(json_response.fetch('items'))
          .to match events.collect { |e| { 'href' => event_url(e.public_uid) } }
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
    Given!(:desired_tag_event) do
      create(:event, :processed, arguments: [create(:argument, name: 'tag_my2')])
    end

    Given!(:diferent_tag_event) do
      create(:event, :processed, arguments: [create(:argument, name: 'foo')])
    end

    Given(:events_json_event_hrefs) { json_response.fetch('items').collect{ |h| h.fetch('href') } }

    When do
      header('Authorization', "Token #{token}")
      get("/v1/events?q[tag_my2]=user_1235")
    end

    Then do
      expect(events_json_event_hrefs).to     include event_url(desired_tag_event.public_uid)
      expect(events_json_event_hrefs).not_to include event_url(diferent_tag_event.public_uid)
    end
  end
end
