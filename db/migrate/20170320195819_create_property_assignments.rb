class CreatePropertyAssignments < ActiveRecord::Migration
  def change
    create_table :property_assignments do |t|
      t.integer :field_id
      t.integer :property_id
      t.integer :value_id

      t.timestamps null: false
    end
  end
end
