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
  has_many :property_assignments, dependent: :destroy, inverse_of: :field
  has_many :properties, through: :property_assignments

  validates :name, 
    format: {with: /\A[a-z].*\Z/, message: "Must not start with capital letter"},
    presence: true, 
    uniqueness: {scope: :table_id, message:"Field already present in table"}

  validates :table, presence: :true

  validates :data_type_id, presence: :true
  
end
