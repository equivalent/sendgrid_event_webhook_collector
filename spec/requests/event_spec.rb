require 'ar_spec_helper'

RSpec.describe 'GET /v1/events/uid12345' do
  include Rack::Test::Methods

  Given!(:event) { create(:event, :processed) }
  Given!(:token) { create(:user).token }

  When do
    get("/v1/events/#{event.public_uid}?token=#{token}")
  end

  Then do
    expect(last_response.status).to be 200
  end

  Then do
    expect(json_response).to be_kind_of Hash
    expect(json_response.fetch('name')).to eq event.name
  end

  context do
    Given!(:token) { create(:user, application_name: "different_app").token }

    Then do
      expect(last_response.status).to be 403
    end
  end
end
