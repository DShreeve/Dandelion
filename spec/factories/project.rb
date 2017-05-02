FactoryGirl.define do
  
  factory :project do
    name { "Project" + random_word}
    description  "Dummy Information"
  end
  
end

def random_word
  ('a'..'z').to_a.shuffle.join
end