class AddProjectManagerIdToProject < ActiveRecord::Migration
  def change
    add_column :projects, :project_manager_id, :integer
  end
end
