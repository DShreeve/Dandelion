class Field < ActiveRecord::Base
  belongs_to :table
  has_many :property_assignments, dependent: :destroy
  has_many :properties, through: :property_assignments
end
