class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.date :actual_date
      t.integer :budget

      t.timestamps null: false
    end
  end
end
