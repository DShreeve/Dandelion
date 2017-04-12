# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

data_types = [
  ["Integer","Integer data type"], #1
  ["String","String data type"], #2
  ["Boolean","Boolean data type"], #3
]

data_types.each do |name, desc|
  DataType.create( name: name, description: desc)
end

properties = [
  ["Greater than", "Value must be greater than value specified", ">",  1,  1],
  ["Greater than or equal to", "Value must be greater than or equal to value specified", ">=",  1,  1],
  ["Equal to", "Value must be equal to value specified", "==",  1,  1],
  ["Less than or equal to", "Value must be less than or equal to value specified", "<=",  1,  1],
  ["Less than", "Value must be less than value specified", "<",  1,  1],
  ["Other than", "Value must be a value that is not value specified", "!=",  1,  1],
  ["Is odd", "Value must be odd", "%2 = 1",  1,  3],
  ["Is even", "Value must be even", "%2 = 0",  1,  3]

]

properties.each do |name, desc, rule, field_data_type, value_data_type|
  Property.create( name: name, description: desc, rule: rule, field_data_type_id: field_data_type, value_data_type_id: value_data_type)
end

project = Project.create( name: "Test Project", description: "A Project for testing")

employee = project.tables.create( name: "Employee", description: "Employee Information")

store = project.tables.create( name: "Store", description: "Store Information")

vehicle = project.tables.create( name: "Vehicle", description: "Vehicle Information")

