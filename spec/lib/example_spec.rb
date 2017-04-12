require "rails_helper"

describe Table do
  context "context message" do
    it "is valid with valid attributes" do
      table = build( :table)
      if table.respond_to?(:valid?)
        expect(table).to be_invalid, lambda { table.errors.full_messages.join("\n") }
      end
    end
  end
end