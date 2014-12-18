require 'spec_helper'

RSpec.describe EventProcessor do
  Given(:event) { OpenStruct.new arguments: [], save: true }
  Given(:raw)   { JSONFixture.new('sendgrid_event.json').to_hash }
  Given(:custom_whitelist) { %w(id tag1 tag_my2) }

  Given(:processor) do
    described_class.new.tap do |ep|
      ep.custom_whitelist = custom_whitelist
      ep.event = event
      ep.raw = raw
    end
  end

  When do
    expect(event).to receive(:save)
    processor.call
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
        e.attributes.slice('name', 'type', 'value')
      end
  end

  Then do
    expect(event_args_attributes.size).to be 8
  end

  Then do
    expect(event_args_attributes).to include( {
      'name' => 'id',
      'type' => 'CustomArgument',
      'value' => '001' } )
  end

  Then do
    expect(event_args_attributes).to include( {
      'name' => 'tag1',
      'type' => 'CustomArgument',
      'value' => 'invitation' } )
  end

  Then do
    expect(event_args_attributes).to include( {
      'name' => 'tag_my2',
      'type' => 'CustomArgument',
      'value' => 'user_1235' } )
  end

  Then do
    expect(event_args_attributes).to include( {
      'name' => 'name',
      'type' => 'SendgridArgument',
      'value' => 'processed' })
  end

  Then do
    expect(event_args_attributes).to include( {
      'name' => 'email',
      'type' => 'SendgridArgument',
      'value' => 'john.doe@sendgrid.com' } )
  end

  Then do
    expect(event_args_attributes).to include( {
      'name' => nil,
      'type' => 'Category',
      'value' => 'production' } )
  end

  Then do
    expect(event_args_attributes).to include( {
      'name' => nil,
      'type' => 'Category',
      'value' => 'my_app' } )
  end

  Then do
    expect(event_args_attributes).to include( {
      'name' => nil,
      'type' => 'Category',
      'value' => 'category3' } )
  end
end
