FactoryGirl.define do

  factory :data_type do
    sequence(:name) { |n| "Name#{n}"}
    description "Dummy Information"
  end
  
end