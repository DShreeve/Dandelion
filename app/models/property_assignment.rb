# == Schema Information
#
# Table name: property_assignments
#
#  id          :integer          not null, primary key
#  field_id    :integer
#  property_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class PropertyAssignment < ActiveRecord::Base
  belongs_to :property
  belongs_to :field
  has_one :value, dependent: :destroy, inverse_of: :property_assignment_id

  validates :field_id, presence: true

  validates :property_id, presence: true


end
