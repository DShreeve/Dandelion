require "spec_helper"

desrcibe "Employee" do

	it "has a valid factory" do
		expect(build(:employee)).to be_valid
	end

	describe "first_name field has property" do

	end

	describe "last_name field has property" do

	end

	describe "age field has property" do

		context "Greater than or equal to 18" do
			it "generated a correct valid value" do
				expect(<@valid>).to be >= 18
			end
			it "is valid with generated value" do
				employee = build(:employee,age: <@valid>)
				if employee.respond_to?(:valid?)
					expect(employee).to be_valid, lambda { employee.errors.full_messages.join("\n") }
				end
			end
			it "generated a correct invalid value" do
				expect(<@in_valid>).to_not be >= 18
			end
			it "is invalid with generated value" do
				employee = build(:employee,age: <@in_valid>)
				if employee.respond_to?(:valid?)
					expect(employee).to_not be_valid, lambda { employee.errors.full_messages.join("\n") }
				end
			end
		end

		context "Less than 80" do
			it "generated a correct valid value" do
				expect(<@valid>).to be < 80
			end
			it "is valid with generated value" do
				employee = build(:employee,age: <@valid>)
				if employee.respond_to?(:valid?)
					expect(employee).to be_valid, lambda { employee.errors.full_messages.join("\n") }
				end
			end
			it "generated a correct invalid value" do
				expect(<@in_valid>).to_not be < 80
			end
			it "is invalid with generated value" do
				employee = build(:employee,age: <@in_valid>)
				if employee.respond_to?(:valid?)
					expect(employee).to_not be_valid, lambda { employee.errors.full_messages.join("\n") }
				end
			end
		end

	end

end
