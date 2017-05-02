require "rails_helper"

describe ValidationAssignment do

  it "cannot assign a validation to a non existant field" do
    validation = create(:validation)
    validation_assignment = build(:validation_assignment, field_id: 2,
      validation_id: validation.id)
    expect(validation_assignment).to_not be_valid
  end

end