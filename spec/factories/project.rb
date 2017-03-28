FactoryGirl.define do
  

  factory :project do
    sequence(:name) { |n| "Name#{n}"}
    description  "Dummy Information"
  end




end