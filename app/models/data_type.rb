# == Schema Information
#
# Table name: data_types
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class DataType < ActiveRecord::Base
end
