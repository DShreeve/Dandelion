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
  has_many :property_assignments, dependent: :destroy
  has_many :fields, through: :property_assignments
end
