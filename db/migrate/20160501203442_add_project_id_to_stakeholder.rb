class AddProjectIdToStakeholder < ActiveRecord::Migration
  def change
    add_column :stakeholders, :project_id, :integer
  end
end
