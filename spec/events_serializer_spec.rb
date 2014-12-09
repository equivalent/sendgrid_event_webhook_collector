require 'spec_helper'

RSpec.describe EventsSerializer do
  load AppPath::Test.fixture.join('event_full_hash.rb')

  describe '#to_hash' do
    Given!(:event1) { create :event, :processed }
    Given!(:event2) { create :event, :processed }
    Given(:scope) { Event.all }
    Given(:subject) { described_class.new(scope, params).to_hash }

    context 'without expand' do
      Given(:params) { {} }

      Then do
        expect(subject).to match(
          {
            href: "http://api.myapp.com/v1/events?offset=0&limit=40",
            limit: 40,
            offset: 0,
            first: '',
            next: "",
            previous: "",
            last: "",
            items: [
              { 'href' => event_url(event1.public_uid) },
              { 'href' => event_url(event2.public_uid) }
            ]
          }
        )
      end
    end

    context 'with items expand and changed offset' do
      Given(:params) { { expand: 'items', offset: '1', limit: 1  } }

      Then do
        expect(subject).to match(
          {
            href: "http://api.myapp.com/v1/events?offset=1&limit=1&expand=items",
            limit: 1,
            offset: 1,
            first: '',
            next: "",
            previous: "",
            last: "",
            items: [
              event_full_hash(event: event2)
            ]
          }
        )
      end
    end
  end
end
