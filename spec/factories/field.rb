FactoryGirl.define do
  factory :field do
    name { "field_" + random_word_lc }
    description "Dummy Information"
    table
    data_type_id 1
  end
end
def random_word_lc
  ('a'..'z').to_a.shuffle.join
end