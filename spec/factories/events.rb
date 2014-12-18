FactoryGirl.define do
  factory :event do
    raw JSONFixture.new('sendgrid_event.json').to_hash

    trait :with_public_uid do
      public_uid 'abcdefgh'
    end

    trait :processed do
      processed_at 2.days.ago
      occurred_at Time.at(1386636112)

      transient do
        category_values %w(production my_app category3)
      end

      after :build do |event, evaluator|
        event.arguments = [
          build(:sendgrid_argument, name: 'name', value: 'processed'),
          build(:sendgrid_argument, name: 'email', value: 'john.doe@sendgrid.com'),
        ] + evaluator.category_values.collect { |cv| build(:category, value: cv) }
      end
    end

    trait :with_argument do
      after :create do |event|
        event.arguments << create(:custom_argument)
      end
    end

    trait :with_categories do
      after :create do |event|
        ['production', 'my_app', 'category3'].each do |category_name|
          event.categories.create value: category_name
        end
      end
    end
  end
end
