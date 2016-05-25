class AddProjectIdToPrecedent < ActiveRecord::Migration
  def change
    add_column :precedents, :project_id, :integer
  end
end
