class CreateHumanResources < ActiveRecord::Migration
  def change
    create_table :human_resources do |t|
      t.string :name
      t.integer :project_id
      t.boolean :is_from_admin
      t.integer :experience
      t.integer :salary

      t.timestamps null: false
    end
  end
end
