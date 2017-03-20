class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :name
      t.string :description
      t.string :rule
      t.integer :field_data_type_id
      t.integer :value_data_type_id

      t.timestamps null: false
    end
  end
end
