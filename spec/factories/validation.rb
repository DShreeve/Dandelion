FactoryGirl.define do

  factory :validation do
    name { "Validation" + random_word }
    description "Dummy Information"
    rule "rule"
    field_data_type_id 1
    value_data_type_id 1
  end
  
end

def random_word
  ('A'..'Z').to_a.shuffle.join
end