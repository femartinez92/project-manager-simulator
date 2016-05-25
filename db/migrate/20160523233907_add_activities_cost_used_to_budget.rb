class AddActivitiesCostUsedToBudget < ActiveRecord::Migration
  def change
    add_column :budgets, :activities_cost_used, :integer
  end
end
