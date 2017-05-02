require "rails_helper"

describe Table do

  it "can be created" do
    table = create( :table)
    expect(Table.where(id: table.id).length).to eq(1)
  end
  
  it "can not be created without a project" do
    table = build( :table, project_id: 1)
    expect(table).to_not be_valid
  end

  it "can be edited" do
    table = create( :table, name:"Table")
    table.name = "Change"
    table.save
    expect(Table.where(id: table.id).first.name).to eq("Change")
  end

  it "can be deleted" do
    table = create( :table)
    table.destroy
    expect(Table.where(id: table.id).length).to eq(0)
  end

  it "deletes associated tables when deleted" do
    table = create( :table)
    field = create(:field, table_id: table.id)
    table.destroy
    expect(Field.where(id: field.id).length).to eq(0)
  end

end