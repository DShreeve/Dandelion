class Property < ActiveRecord::Base
  has_many :property_assignments, dependent: :destroy
  has_many :fields, through: :property_assignments
end
