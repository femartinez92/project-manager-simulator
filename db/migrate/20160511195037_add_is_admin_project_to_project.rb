class AddIsAdminProjectToProject < ActiveRecord::Migration
  def change
    add_column :projects, :is_admin_project, :boolean
  end
end
