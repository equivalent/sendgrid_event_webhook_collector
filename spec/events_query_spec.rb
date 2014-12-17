require 'ar_spec_helper'

RSpec.describe EventsQuery do

  describe '#search' do
    Given(:subject) { query.search(criteria) }
    Given(:query) { described_class.new(scope) }
    Given(:scope) { Event.all }

    Given!(:event_matching_arg) do
      create :event, arguments: [
        create(:argument, name: 'my_tag', value: 'foo')
      ]
    end

    Given!(:event_matching_arg_key_not_value) do
      create :event, arguments: [
        create(:argument, name: 'my_tag', value: 'bar')
      ]
    end

    context 'no search criteria' do
      Given(:criteria) { {} }

      Then do
        expect(subject.size).to eq scope.size
      end
    end

    context 'one search criteria' do
      Given(:criteria) { { 'my_tag' => 'foo' } }

      Then do
        expect(subject).to     include event_matching_arg
        expect(subject).not_to include event_matching_arg_key_not_value
      end
    end

    context 'two search criteria' do
      Given(:criteria) { { 'my_tag' => 'foo', 'warCar' => 'dar' } }

      Given!(:event_matching_two_arg) do
        create :event, arguments: [
          create(:argument, name: 'my_tag', value: 'foo'),
          create(:argument, name: 'warCar', value: 'dar'),
        ]
      end

      Then do
        expect(subject).to     include event_matching_two_arg
        expect(subject).not_to include event_matching_arg_key_not_value,
                                       event_matching_arg
      end
    end
  end
end
