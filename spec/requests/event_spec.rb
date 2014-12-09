require 'spec_helper'

RSpec.describe 'GET /events/uid12345' do
  Given!(:event) { create(:event, :processed) }

  When do
    get("/events/#{event.public_uid}")
  end

  Then do
    expect(json_response).to be_kind_of Hash
    expect(json_response.fetch('name')).to eq event.name
  end
end
