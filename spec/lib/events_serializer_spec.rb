require 'ar_spec_helper'

RSpec.describe EventsSerializer do
  describe '#to_hash' do
    Given!(:event1) { create :event, :processed, :with_argument }
    Given!(:event2) { create :event, :processed }
    Given(:scope) { Event.all }
    Given(:subject) do
      described_class
        .new(scope, params)
        .tap { |serial| serial.authority = 'http://api.myapp.com' }
        .to_hash
    end

    context 'without expand' do
      Given(:params) { {} }

      Then do
        expect(subject).to match(
          {
            href: "http://api.myapp.com/v1/events?offset=0&limit=40",
            limit: 40,
            offset: 0,
            first: "http://api.myapp.com/v1/events?offset=0&limit=40",
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
      Given!(:event3) { create :event, :processed, :with_argument }

      Then do
        expect(subject).to match(
          {
            href: "http://api.myapp.com/v1/events?offset=1&limit=1&expand=items",
            limit: 1,
            offset: 1, # so second page
            first:    "http://api.myapp.com/v1/events?offset=0&limit=1&expand=items",
            next:     "http://api.myapp.com/v1/events?offset=2&limit=1&expand=items",
            previous: "http://api.myapp.com/v1/events?offset=0&limit=1&expand=items",
            last: "",
            items: [
              {
                'href' => "http://api.myapp.com/v1/events/#{event2.public_uid}",
                'id' => event2.public_uid,
                'name' =>  'processed',
                'email' => 'john.doe@sendgrid.com',
                'categories' => ['category3', 'my_app', 'production'],
                'occurredAt' => '2013-12-10T00:41:52Z',
              }
            ]
          }
        )
      end
    end

    context 'without search query' do
      Given(:params) { { 'q' => { 'metalCore' => 'B.M.T.H'} } }

      Then do
        expect(subject).to match(
          {
            href: "http://api.myapp.com/v1/events?offset=0&limit=40",
            limit: 40,
            offset: 0,
            first: "http://api.myapp.com/v1/events?offset=0&limit=40",
            next: "",
            previous: "",
            last: "",
            items: [
              { 'href' => event_url(event1.public_uid) },
            ]
          }
        )
      end
    end
  end
end
