# == Schema Information
#
# Table name: properties
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

class Property < ActiveRecord::Base
  has_many :property_assignments, dependent: :destroy, inverse_of: :property_id
  has_many :fields, through: :property_assignments, inverse_of: :field_id

  validates :name, format: {with: /\A[A-Z].*\Z/, message: "Must start with capital letter"},
    presence: true, uniqueness: true

  validates :field_data_type_id, presence: :true

  validates :value_data_type_id, presence: :true

end
