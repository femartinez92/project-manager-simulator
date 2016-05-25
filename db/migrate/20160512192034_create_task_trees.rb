class CreateTaskTrees < ActiveRecord::Migration
  def change
    create_table :task_trees do |t|
      t.integer :father_id
      t.integer :child_id

      t.timestamps null: false
    end
  end
end
