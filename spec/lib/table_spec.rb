require "rails_helper"
require "table"

describe Table do
  
  it "is valid with valid attributes" do
    table = build( :table)
    if table.respond_to?(:valid?)
      expect(table).to be_valid, lambda { table.errors.full_messages.join("\n") }
    end
  end

  it "is not valid without a name" do
    table = build( :table, name: nil)
    if table.respond_to?(:valid?)
      expect(table).to_not be_valid, lambda { table.errors.full_messages.join("\n") }
    end
  end

  it "is not valid without a capitalised name" do
    table = build( :table, name: "lowercase")
    if table.respond_to?(:valid?)
      expect(table).to_not be_valid, lambda { table.errors.full_messages.join("\n") }
    end
  end

  it "is valid without a description" do
    table = build( :table, description: nil)
    if table.respond_to?(:valid?)
      expect(table).to be_valid, lambda { table.errors.full_messages.join("\n") }
    end
  end


end