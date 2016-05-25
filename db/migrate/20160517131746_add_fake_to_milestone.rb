class AddFakeToMilestone < ActiveRecord::Migration
  def change
    add_column :milestones, :fake, :boolean
  end
end
