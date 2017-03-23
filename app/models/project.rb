class Project < ActiveRecord::Base
  has_many :tables, dependent: :destroy
end
