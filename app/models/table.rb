class Table < ActiveRecord::Base
  belongs_to :project
  has_many :fields, dependent: :destroy
end
