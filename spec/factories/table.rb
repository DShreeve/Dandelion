FactoryGirl.define do

  factory :table do
    name { "Table" + random_word }
    description "Dummy Information"
    project
  end

end

def random_word
  ('a'..'z').to_a.shuffle.join
end