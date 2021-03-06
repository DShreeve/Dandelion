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
  ["Float", "Float data type"] #4
]

data_types.each do |name, desc|
  DataType.create( name: name, description: desc)
end

int_validations = [
  ["Greater than", "Integer must be greater than Integer specified", ">",  1,  1],
  ["Greater than or equal to", "Integer must be greater than or equal to Integer specified", ">=",  1,  1],
 # ["Equal to", "Integer must be equal to Integer specified", "==",  1,  1],
  ["Less than or equal to", "Integer must be less than or equal to value specified", "<=",  1,  1],
  ["Less than", "Integer must be less than value specified", "<",  1,  1],
 # ["Other than", "Integer must be a value that is not value specified", "!=",  1,  1],
  ["Divisible", "Integer must be divisible by given Integer", "divisible",  1,  1],
  ["Exclusion", "Integer in list will not be accepted", "exclusion", 1, 2],
  ["Inclusion", "Integer in list will ONLY be accpeted", "inclusion", 1,2],
  ["Blank", "Field can be left blank/nil", "blank", 1, 3]

]

int_validations.each do |name, desc, rule, field_data_type, value_data_type|
  Validation.create( name: name, description: desc, rule: rule, field_data_type_id: field_data_type, value_data_type_id: value_data_type)
end

float_validations = [
  ["Greater than", "Float must be greater than Float specified", ">",  4,  4],
  ["Greater than or equal to", "Float must be greater than or equal to Float specified", ">=",  4,  4],
  #["Equal to", "Float must be equal to Float specified", "==",  4,  4],
  ["Less than or equal to", "Float must be less than or equal to value specified", "<=",  1,  4],
  ["Less than", "Float must be less than value specified", "<",  4,  4],
  #["Other than", "Float must be a value that is not value specified", "!=",  4,  4],
  ["Divisible", "Float must be divisible by given Float", "divisible",  4,  4],
  ["Exclusion", "Float in list will not be accepted", "exclusion", 4, 2],
  ["Inclusion", "Float in list will ONLY be accpeted", "inclusion", 4,2],
  ["Blank", "Field can be left blank/nil", "blank", 4, 3]

]

float_validations.each do |name, desc, rule, field_data_type, value_data_type|
  Validation.create( name: name, description: desc, rule: rule, field_data_type_id: field_data_type, value_data_type_id: value_data_type)
end

string_validations = [
  ["Exclusion", "String in list will not be accepted", "exclusion", 2, 2],
  ["Inclusion", "String in list will ONLY be accpeted", "inclusion", 2,2],
  ["Format", "String must match regex to be accepted","regex", 2, 2],
  ["Minimum Length", "String must exceed length given", ">", 2, 1],
  ["Maximum Length", "String must not exceed length given", "<", 2, 1],
  ["Exact Length", "String must be of length given", "==", 2, 1],
  ["Blank", "Field can be left blank/nil", "blank", 2, 3]


]

string_validations.each do |name, desc, rule, field_data_type, value_data_type|
  Validation.create( name: name, description: desc, rule: rule, field_data_type_id: field_data_type, value_data_type_id: value_data_type)
end



project = Project.create( name: "Test Project", description: "A Project for testing")

employee = project.tables.create( name: "Employee", description: "Employee Information")

employee_first_name = employee.fields.create( name: "first_name", description: "First name of employee", data_type_id: 2 )

employee_last_name = employee.fields.create( name: "last_name", description: "Surname of employee", data_type_id: 2 )
employee_age = employee.fields.create( name: "age", description: "Age of employee", data_type_id: 1 )
employee_age_gt = employee_age.validation_assignments.create(validation_id: 2)
employee_age_gt.create_value(value:"18",data_type_id: 1)
employee_age_lt = employee_age.validation_assignments.create(validation_id: 5)
employee_age_lt.create_value(value:"80",data_type_id: 1)

store = project.tables.create( name: "Store", description: "Store Information")

vehicle = project.tables.create( name: "Vehicle", description: "Vehicle Information")

