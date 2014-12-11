FactoryGirl.define do
  factory :event do
    raw JSONFixture.new('sendgrid_event.json').to_hash

    trait :processed do
      processed_at 2.days.ago
      categories ['production', 'my_app', 'category3']
      name 'bounce'
      email 'oliver.scott.sykes@test.bmth'
      occurred_at Time.at(1386636112)
    end
  end
end
