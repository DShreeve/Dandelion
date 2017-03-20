class CreatePropertyAssignments < ActiveRecord::Migration
  def change
    create_table :property_assignments do |t|
      t.belongs_to :field, index: true
      t.belongs_to :property, index: true

      t.timestamps null: false
    end
  end
end
