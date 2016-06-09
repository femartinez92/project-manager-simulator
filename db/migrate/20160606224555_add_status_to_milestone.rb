class AddStatusToMilestone < ActiveRecord::Migration
  def change
    add_column :milestones, :status, :string
  end
end
