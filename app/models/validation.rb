# == Schema Information
#
# Table name: validations
#
#  id                 :integer          not null, primary key
#  name               :string
#  description        :string
#  rule               :string
#  field_data_type_id :integer
#  value_data_type_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Validation < ActiveRecord::Base
  has_many :validation_assignments, dependent: :destroy, inverse_of: :validation_id
  has_many :fields, through: :validation_assignments, inverse_of: :field_id

  validates :name, format: {with: /\A[A-Z].*\Z/, message: "Must start with capital letter"},
    presence: true, uniqueness: {scope: :field_data_type_id} 

  validates :field_data_type_id, presence: :true

  validates :value_data_type_id, presence: :true

end
