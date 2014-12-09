require 'spec_helper'

RSpec.describe 'GET /events' do
  Given!(:events) do
    [
      create(:event, :processed),
      create(:event, :processed),
      create(:event, :processed)
    ]
  end

  When do
    get('/events')
  end

  Then do
    expect(json_response).to be_kind_of Hash
    expect(json_response.fetch('items'))
      .to match events.collect { |e| { 'href' => event_url(e.public_uid) } }
  end
end
