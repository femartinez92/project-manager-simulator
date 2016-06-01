class AddStrategicObjectiveToProject < ActiveRecord::Migration
  def change
    add_column :projects, :strategic_objective, :text
  end
end
