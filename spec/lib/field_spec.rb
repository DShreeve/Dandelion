require "rails_helper"

describe Field do

  it "can be created" do
    field = create( :field)
    expect(Field.where(id: field.id).length).to eq(1)
  end
  
  it "can not be created without a project" do
    field = build( :field, table_id: 1)
    expect(field).to_not be_valid
  end

  it "can be edited" do
    field = create( :field, name:"field")
    field.name = "change"
    field.save
    expect(Field.where(id: field.id).first.name).to eq("change")
  end

  it "can be deleted" do
    field = create( :field)
    field.destroy
    expect(Field.where(id: field.id).length).to eq(0)
  end

  it "deletes associated fields when deleted" do
    field = create( :field)
    validation_assignment = create(:validation_assignment, field_id: field.id)
    field.destroy
    expect(ValidationAssignment.where(id: validation_assignment.id).length).to eq(0)
  end

  it "can have a given validation" do
    field = create( :field)
    validation = create(:validation)
    validation_assignment = create(:validation_assignment, field_id: field.id,
      validation_id: validation.id)
    expect(ValidationAssignment.where(id: validation_assignment.id).first.field_id).to eq(field.id)
  end

end