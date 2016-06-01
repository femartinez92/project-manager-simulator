class AddProjectTypeIdToProjectManager < ActiveRecord::Migration
  def change
    add_column :project_managers, :project_type_id, :integer
  end
end
