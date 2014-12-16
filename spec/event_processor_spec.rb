require 'spec_helper'

RSpec.describe EventProcessor do
  Given(:event) { OpenStruct.new arguments: [], save: true }
  Given(:raw)   { JSONFixture.new('sendgrid_event.json').to_hash }
  Given(:whitelist) { %w(id tag1 tag_my2) }

  Given(:processor) do
    described_class.new.tap do |ep|
      ep.event = event
      ep.raw = raw
      ep.whitelist = whitelist
    end
  end

  When do
    expect(event).to receive(:save)
    processor.call
  end

  Then do
    expect(event.email).to eq "john.doe@sendgrid.com"
  end

  Then do
    expect(event.name).to eq "processed"
  end

  Then do
    expect(event.processed_at).to be_within(2.seconds).of(Time.now)
  end

  Then do
    expect(event.occurred_at.utc.to_s).to eq "2013-12-10 00:41:52 UTC"
  end

  Given(:event_args_attributes) do
    event
      .arguments
      .collect do |e|
        e.attributes.slice('name', 'value')
      end
  end

  Then do
    expect(event.categories).to include('production', 'my_app', 'category3')
  end

  Then do
    expect(event_args_attributes)
      .to match [
        { 'name' => 'id', 'value' => '001' },
        { 'name' => 'tag1', 'value' => 'invitation' },
        { 'name' => 'tag_my2', 'value' => 'user_1235' },
      ]
  end
end
