class PropertyAssignment < ActiveRecord::Base
  belongs_to :property
  belongs_to :field
  has_one :value, dependent: :destroy
end
