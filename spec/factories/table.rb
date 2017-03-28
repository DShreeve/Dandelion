FactoryGirl.define do

  factory :table do
    sequence(:name) { |n| "Name#{n}"}
    description "Dummy Information"
    project
  end


end