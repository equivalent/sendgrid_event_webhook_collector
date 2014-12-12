FactoryGirl.define do
  factory :user do
    name "Oli BMTH"
    application_name 'my_app'

    trait :creator do
      creator true
    end
  end
end
