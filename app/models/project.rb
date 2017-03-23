# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Project < ActiveRecord::Base
  has_many :tables, dependent: :destroy, inverse_of: :project
  
  validates :name, format: {with: /\A[A-Z].*\Z/, message: "Must start with capital letter"},
    presence: true, uniqueness: true

  
end
