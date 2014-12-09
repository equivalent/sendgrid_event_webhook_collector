require 'spec_helper'
RSpec.describe EventSerializer do
  load AppPath::Test.fixture.join('event_full_hash.rb')

  describe '#to_hash' do
    Given(:event)  { build :event, :processed }
    When(:subject) { described_class.new(event).to_hash }

    Then do
      expect(subject).to match(
        event_full_hash(event: event)
      )
    end
  end
end
