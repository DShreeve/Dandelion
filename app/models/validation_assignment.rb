# == Schema Information
#
# Table name: validation_assignments
#
#  id          :integer          not null, primary key
#  field_id    :integer
#  validation_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class ValidationAssignment < ActiveRecord::Base
  belongs_to :validation
  belongs_to :field
  has_one :value, dependent: :destroy, inverse_of: :validation_assignment

  validates :field_id, presence: true

  validates :validation_id, presence: true


end
