class CreateResourceAssignations < ActiveRecord::Migration
  def change
    create_table :resource_assignations do |t|
      t.integer :human_resource_id
      t.integer :task_id
      t.integer :time

      t.timestamps null: false
    end
  end
end
