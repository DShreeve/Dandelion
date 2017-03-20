class CreateTables < ActiveRecord::Migration
  def change
    create_table :tables do |t|
      t.string :name
      t.string :description
      t.belongs_to :project, index: true

      t.timestamps null: false
    end
  end
end
