class AddAdvancePercentageToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :advance_percentage, :integer
  end
end
