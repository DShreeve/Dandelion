require "rails_helper"
require "project"

describe Project do
  
  it "is valid with valid attributes" do
    project = build( :project)
    if project.respond_to?(:valid?)
      expect(project).to be_valid, lambda { project.errors.full_messages.join("\n") }
    end
  end

  it "is not valid without a name" do
    project = build( :project, name: nil)
    if project.respond_to?(:valid?)
      expect(project).to_not be_valid, lambda { project.errors.full_messages.join("\n") }
    end
  end

  it "is not valid without a capitalised name" do
    project = build( :project, name: "lowercase")
    if project.respond_to?(:valid?)
      expect(project).to_not be_valid, lambda { project.errors.full_messages.join("\n") }
    end
  end

  it "is valid without a description" do
    project = build( :project, description: nil)
    if project.respond_to?(:valid?)
      expect(project).to be_valid, lambda { project.errors.full_messages.join("\n") }
    end
  end


end