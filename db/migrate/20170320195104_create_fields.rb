class CreateFields < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.string :name
      t.string :description
      t.integer :table_id
      t.integer :data_type_id

      t.timestamps null: false
    end
  end
end
