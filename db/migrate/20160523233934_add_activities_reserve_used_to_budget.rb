class AddActivitiesReserveUsedToBudget < ActiveRecord::Migration
  def change
    add_column :budgets, :activities_reserve_used, :integer
  end
end
