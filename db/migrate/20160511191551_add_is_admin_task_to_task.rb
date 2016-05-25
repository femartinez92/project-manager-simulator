class AddIsAdminTaskToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :is_admin_task, :boolean
  end
end
