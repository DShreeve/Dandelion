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
  has_one :value, dependent: :destroy
end
