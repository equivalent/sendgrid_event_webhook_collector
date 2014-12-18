require 'spec_helper'
RSpec.describe EventSerializer do

  describe '#to_hash' do
    Given(:event) do
      build(:event, :processed, :with_public_uid).tap do |event|
        event.arguments << build(:custom_argument, name: 'my_arg', value: 'awesome')
        event.arguments << build(:custom_argument, name: 'otherArg', value: 'more awesome')
      end
    end

    When(:subject) do
      described_class
        .new(event)
        .tap { |serial| serial.authority = 'http://api.myapp.com' }
        .to_hash
    end

    Then do
      expect(subject).to match( {
        'id' => 'abcdefgh',
        'href' => 'http://api.myapp.com/v1/events/abcdefgh',
        'categories' => ['category3', 'my_app', 'production'],
        'name' =>  'processed',
        'email' => 'john.doe@sendgrid.com',
        'occurredAt' => '2013-12-10T00:41:52Z',
        'myArg' => "awesome",
        'otherArg' => "more awesome",
        #'sendgrid' => {
          #"email"=>"john.doe@sendgrid.com",
          #"sgEventId"=>"VzcPxPv7SdWvUugt-xKymw",
          #"sgMessageId"=>"142d9f3f351.7618.254f56.filter-147.22649.52A663508.0",
          #"timestamp"=>1386636112,
          #"smtp-id"=>"<142d9f3f351.7618.254f56@sendgrid.com>",
          #"event"=>"processed",
          #"category"=>["production", "my_app", "category3"],
          #"id"=>"001",
          #"tag1"=>"invitation",
          #"tagMy2"=>"user_1235"
        #}
      })
    end
  end
end
