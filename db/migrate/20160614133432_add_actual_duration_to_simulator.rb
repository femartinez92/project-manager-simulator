class AddActualDurationToSimulator < ActiveRecord::Migration
  def change
    add_column :simulators, :actual_duration, :integer
  end
end
