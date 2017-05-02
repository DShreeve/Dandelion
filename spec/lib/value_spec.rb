require "rails_helper"

describe Value do

  it "can be created" do
    value = create( :value)
    expect(Value.where(id: value.id).length).to eq(1)
  end
  
  it "can not be created without a validation_assignment" do
    value = build( :value, validation_assignment_id: 1)
    expect(value).to_not be_valid
  end

  it "can be edited" do
    value = create( :value, value:"Table")
    value.value = "Change"
    value.save
    expect(Value.where(id: value.id).first.value).to eq("Change")
  end
  
end