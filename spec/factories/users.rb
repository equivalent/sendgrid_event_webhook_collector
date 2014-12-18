FactoryGirl.define do
  factory :user do
    name "Oli Skyes"
    application_name 'my_app'

    trait :creator do
      creator true
    end
  end
end
