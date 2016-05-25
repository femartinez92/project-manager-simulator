class AddIsAdminMilestoneToMilestone < ActiveRecord::Migration
  def change
    add_column :milestones, :is_admin_milestone, :boolean
  end
end
