def event_full_hash(options={})
  event = options.fetch(:event) do
    OpenStruct.new public_uid: 'abcdefgh',
      name: 'processed',
      email: 'john.doe@sendgrid.com'
  end

  {
    'href' => "http://api.myapp.com/v1/events/#{event.public_uid}",
    'categories' => ['production', 'my_app', 'category3'],
    'name' => event.name,
    'email' => event.email,
    'occurredAt' => '2013-12-10T00:41:52Z',
    'sendgrid' => {
      "email"=>"john.doe@sendgrid.com",
      "sgEventId"=>"VzcPxPv7SdWvUugt-xKymw",
      "sgMessageId"=>"142d9f3f351.7618.254f56.filter-147.22649.52A663508.0",
      "timestamp"=>1386636112,
      "smtp-id"=>"<142d9f3f351.7618.254f56@sendgrid.com>",
      "event"=>"processed",
      "category"=>["production", "my_app", "category3"],
      "id"=>"001",
      "tag1"=>"invitation",
      "tagMy2"=>"user_1235"
    }
  }
end
