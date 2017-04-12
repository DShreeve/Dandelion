require "rails_helper"

describe Table do
  describe "field name" do
    context "property" do
      it "has this behaviour" do
        table = build( :table)
        if table.respond_to?(:valid?)
          expect(table).to be_invalid, lambda { table.errors.full_messages.join("\n") }
        end
      end
      it "and also this" do
        table = build( :table)
        if table.respond_to?(:valid?)
          expect(table).to be_invalid, lambda { table.errors.full_messages.join("\n") }
        end
      end
    end
  end
end