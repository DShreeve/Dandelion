# == Schema Information
#
# Table name: tables
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  project_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Table < ActiveRecord::Base
  belongs_to :project
  has_many :fields, dependent: :destroy, inverse_of: :table

  validates :name, format: {with: /\A[A-Z].*\Z/, message: "Must start with capital letter"},
    presence: true, uniqueness: true

  validates :project, presence: true
end
