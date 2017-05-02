# == Schema Information
#
# Table name: values
#
#  id                     :integer          not null, primary key
#  value                  :string
#  data_type_id           :integer
#  validation_assignment_id :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#



class Value < ActiveRecord::Base
  validate :validation_assignment_exist?
  belongs_to :validation_assignment

  validates :value , presence: true

  validates :data_type_id , presence: true

  validates :validation_assignment_id , presence: true


  def validation_assignment_exist?
    if (ValidationAssignment.where(id: validation_assignment_id).length) < 1
      errors.add(:validation_assignment_presence, "that validation assignment doesnt exist")
    end
  end
end
