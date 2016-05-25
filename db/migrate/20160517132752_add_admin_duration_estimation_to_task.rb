class AddAdminDurationEstimationToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :admin_duration_estimation, :integer
  end
end
