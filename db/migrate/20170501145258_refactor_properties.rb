class RefactorProperties < ActiveRecord::Migration
  def change
    rename_table :properties , :validations
    rename_table :property_assignments, :validation_assignments

    change_table :validation_assignments do |t|
      t.rename :property_id, :validation_id
    end

    change_table :values do|t|
      t.rename :property_assignment_id, :validation_assignment_id
    end
  end
end
