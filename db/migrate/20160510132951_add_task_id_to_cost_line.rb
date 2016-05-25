class AddTaskIdToCostLine < ActiveRecord::Migration
  def change
    add_column :cost_lines, :task_id, :integer
  end
end
