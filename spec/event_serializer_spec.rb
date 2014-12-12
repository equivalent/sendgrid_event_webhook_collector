require 'spec_helper'
RSpec.describe EventSerializer do
  load AppPath::Test.fixture.join('event_full_hash.rb')

  describe '#to_hash' do
    Given(:event)  { build :event, :processed }

    When(:subject) do
      described_class
        .new(event)
        .tap { |serial| serial.authority = 'http://api.myapp.com' }
        .to_hash
    end

    Then do
      expect(subject).to match(
        event_full_hash(event: event, authority: 'http://api.myapp.com')
      )
    end
  end
end
