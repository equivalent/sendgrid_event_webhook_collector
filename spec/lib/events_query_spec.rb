require 'ar_spec_helper'

RSpec.describe EventsQuery do

  describe '#search' do
    Given(:subject) { query.search(criteria) }
    Given(:query) { described_class.new(scope) }
    Given(:scope) { Event.all }

    Given!(:event_matching_arg) do
      create :event, arguments: [
        create(:custom_argument, name: 'my_tag', value: 'foo')
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

      Given!(:event_matching_arg_key_not_value) do
        create :event, arguments: [
          create(:custom_argument, name: 'my_tag', value: 'bar')
        ]
      end

      Then do
        expect(subject).to     include event_matching_arg
        expect(subject).not_to include event_matching_arg_key_not_value
      end
    end

    context 'two search criteria' do
      Given(:criteria) { { 'my_tag' => 'foo', 'warCar' => 'dar' } }

      Given!(:event_matching_two_arg) do
        create :event, arguments: [
          create(:custom_argument, name: 'my_tag', value: 'foo'),
          create(:custom_argument, name: 'warCar', value: 'dar'),
        ]
      end

      Then do
        expect(subject).to     include event_matching_two_arg
        expect(subject).not_to include event_matching_arg
      end
    end

    context 'category, sendgrid and custom arguments' do
      Given(:criteria) do
        {
          'my_tag'   => 'foo',
          'category' => 'vocalist',
          'email'    => 'oliver.scott.sykes@test.bmth'
        }
      end

      Given!(:event_matching_all_args) do
        create :event, arguments: [
          create(:custom_argument, name: 'my_tag', value: 'foo'),
          create(:category, value: 'awesome'),
          create(:category, value: 'vocalist'),
          create(:sendgrid_argument),
        ]
      end

      Given!(:event_matching_args_wrong_category) do
        create :event, arguments: [
          create(:custom_argument, name: 'my_tag', value: 'foo'),
          create(:category, value: 'awesome'),
          create(:sendgrid_argument),
        ]
      end

      Given!(:event_matching_args_wrong_sendgrid) do
        create :event, arguments: [
          create(:custom_argument, name: 'my_tag', value: 'foo'),
          create(:category, value: 'vocalist'),
          create(:sendgrid_argument, value: 'danny@asking-alexandria.test'),
        ]
      end

      Then do
        expect(subject).to include event_matching_all_args
        expect(subject).not_to include event_matching_args_wrong_category
        expect(subject).not_to include event_matching_args_wrong_sendgrid
      end
    end
  end
end
