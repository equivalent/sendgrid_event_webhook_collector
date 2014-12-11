require 'spec_helper'

RSpec.describe 'GET /events' do
  include Rack::Test::Methods

  Given!(:token) { create(:user).token }

  Given!(:events) do
    [
      create(:event, :processed),
      create(:event, :processed),
    ]
  end

  Given!(:other_user_event) do
    create(:event, :processed, categories: ['asking', 'alexandria'])
  end

  context 'using params token' do
    When { get("/events?token=#{token}") }

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
      get("/events")
    end

    Then do
      expect(last_response.status).to be 200
    end
  end

  context 'not passing token any way' do
    When do
      get("/events")
    end

    Then do
      expect(last_response.status).to be 401
    end
  end
end
