class CreateFields < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.string :name
      t.string :description
      t.belongs_to :table, index: true
      t.integer :data_type_id

      t.timestamps null: false
    end
  end
end
