class CreateValues < ActiveRecord::Migration
  def change
    create_table :values do |t|
      t.string :value
      t.integer :data_type_id
      t.belongs_to :property_assignment, index: true

      t.timestamps null: false
    end
  end
end
