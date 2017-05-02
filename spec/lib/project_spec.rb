require "rails_helper"

describe Project do
  
  it "can be created" do
    project = create( :project)
    expect(Project.where(id: project.id).length).to eq(1)
  end

  it "can be edited" do
    project = create( :project, name:"Table")
    project.name = "Change"
    project.save
    expect(Project.where(id: project.id).first.name).to eq("Change")
  end

  it "can be deleted" do
    project = create( :project)
    project.destroy
    expect(Project.where(id: project.id).length).to eq(0)
  end

  it "deletes associated tables when deleted" do
    project = create( :project)
    table = create(:table, project_id: project.id)
    project.destroy
    expect(Table.where(id: table.id).length).to eq(0)
  end

end