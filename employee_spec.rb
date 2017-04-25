require "spec_helper"

desrcibe "Employee" do

	it "has a valid factory" do
		expect(build(:employee)).to be_valid
	end

	describe "first_name field has property" do

		it "can be blank" do 
			employee = build(:employee, first_name: nil)
			if employee.respond_to?(:valid?)
				expect(employee).to be_valid, lambda {employee.errors.full_messages.join("\n")}
			end
		end

		it "is valid with a generated value" do
			employee = build(:employee, first_name: "JLSGmjkLpoygLekshqLFExThAesWmSplqfHTXTnYGUwBZLVC")
			if employee.respond_to?(:valid?)
				expect(employee).to be_valid, lambda {employee.errors.full_messages.join("\n")}
			end
		it "is invalid with value exclusion Gary" do
			employee = build(:employee, first_name: "Gary")
			if employee.respond_to?(:valid?)
				expect(employee).to_not be_valid, lambda {employee.errors.full_messages.join("\n")}
			end
		end

		it "is invalid with value < 67" do
			employee = build(:employee, first_name: "PlJRlxhjSvDrZhKoMkUvxpQnFWFAXidZYOgktEtQnzJVLOyamqTotkrRNsnOFKAPbkgqhphvNAdnDtX")
			if employee.respond_to?(:valid?)
				expect(employee).to_not be_valid, lambda {employee.errors.full_messages.join("\n")}
			end
		end

		it "is invalid with value regex /\A[A-Z]{1}[a-zA-z]*\z/" do
			employee = build(:employee, first_name: "JINtFuKTOmZFIrncsBQl2Zu4Ey0C9LGz3LRq6i3Xq<lpM")
			if employee.respond_to?(:valid?)
				expect(employee).to_not be_valid, lambda {employee.errors.full_messages.join("\n")}
			end
		end

	end

	describe "last_name field has property" do

		it "can not be blank" do 
			employee = build(:employee, last_name: nil)
			if employee.respond_to?(:valid?)
				expect(employee).to_not be_valid, lambda {employee.errors.full_messages.join("\n")}
			end
		end

		it "is valid with a value from inclusion" do
			employee = build(:employee, last_name: "list")
			if employee.respond_to?(:valid?)
				expect(employee).to be_valid, lambda {employee.errors.full_messages.join("\n")}
			end
		it "is invalid with a value not in inclusion" do
			employee = build(:employee, last_name: "i23PGtyeYMDk_fVCMvX78zaft4ar7")
			if employee.respond_to?(:valid?)
				expect(employee).to_not be_valid, lambda {employee.errors.full_messages.join("\n")}
			end
	describe "age field has property" do

		it "can be blank" do 
			employee = build(:employee, age: nil)
			if employee.respond_to?(:valid?)
				expect(employee).to be_valid, lambda {employee.errors.full_messages.join("\n")}
			end
		end

		it "is valid with a generated value" do
			employee = build(:employee, age: 36)
			if employee.respond_to?(:valid?)
				expect(employee).to be_valid, lambda {employee.errors.full_messages.join("\n")}
			end
		it "is invalid with value >= 18" do
			employee = build(:employee, age: 51)
			if employee.respond_to?(:valid?)
				expect(employee).to_not be_valid, lambda {employee.errors.full_messages.join("\n")}
			end
		end

		it "is invalid with value < 80" do
			employee = build(:employee, age: 42)
			if employee.respond_to?(:valid?)
				expect(employee).to_not be_valid, lambda {employee.errors.full_messages.join("\n")}
			end
		end

		it "is invalid with value divisible 3" do
			employee = build(:employee, age: 69)
			if employee.respond_to?(:valid?)
				expect(employee).to_not be_valid, lambda {employee.errors.full_messages.join("\n")}
			end
		end

		it "is invalid with value != 40" do
			employee = build(:employee, age: 51)
			if employee.respond_to?(:valid?)
				expect(employee).to_not be_valid, lambda {employee.errors.full_messages.join("\n")}
			end
		end

	end

	describe "pay field has property" do

		it "can not be blank" do 
			employee = build(:employee, pay: nil)
			if employee.respond_to?(:valid?)
				expect(employee).to_not be_valid, lambda {employee.errors.full_messages.join("\n")}
			end
		end

		it "is valid with a generated value" do
			employee = build(:employee, pay: 9.626251922920346)
			if employee.respond_to?(:valid?)
				expect(employee).to be_valid, lambda {employee.errors.full_messages.join("\n")}
			end
		it "is invalid with value > 5.67" do
			employee = build(:employee, pay: 6.295070420950651)
			if employee.respond_to?(:valid?)
				expect(employee).to_not be_valid, lambda {employee.errors.full_messages.join("\n")}
			end
		end

		it "is invalid with value < 10.0" do
			employee = build(:employee, pay: 7.471336730173789)
			if employee.respond_to?(:valid?)
				expect(employee).to_not be_valid, lambda {employee.errors.full_messages.join("\n")}
			end
		end

	end

end
