# == Schema Information
#
# Table name: values
#
#  id                     :integer          not null, primary key
#  value                  :string
#  data_type_id           :integer
#  property_assignment_id :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class Value < ActiveRecord::Base
  belongs_to :property_assignment
end
