# == Schema Information
#
# Table name: fields
#
#  id           :integer          not null, primary key
#  name         :string
#  description  :string
#  table_id     :integer
#  data_type_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Field < ActiveRecord::Base
  belongs_to :table
  has_many :property_assignments, dependent: :destroy
  has_many :properties, through: :property_assignments
end
