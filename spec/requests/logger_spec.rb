require 'spec_helper'

RSpec.describe 'GET /v1/events' do
  include Rack::Test::Methods

  Given(:request) { get("/v1/status") }

  context 'using params token' do

    Then do
      expect(API.logger)
        .to receive(:info)
        .with '127.0.0.1 GET /v1/status Token: NONE'
      request
      expect(last_response.status).to be 200
    end
  end
end
