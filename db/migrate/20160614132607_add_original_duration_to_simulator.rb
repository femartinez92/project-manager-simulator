class AddOriginalDurationToSimulator < ActiveRecord::Migration
  def change
    add_column :simulators, :original_duration, :integer
  end
end
