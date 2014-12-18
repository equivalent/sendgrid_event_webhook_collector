FactoryGirl.define do
  factory :custom_argument do
    name  'metalCore'
    value 'B.M.T.H'
    type  'CustomArgument'
  end

  factory :sendgrid_argument do
    name  'email'
    value 'oliver.scott.sykes@test.bmth'
    type  'SendgridArgument'
  end

  factory :category do
    value 'music'
    type  'Category'
  end
end
