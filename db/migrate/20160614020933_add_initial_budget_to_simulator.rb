class AddInitialBudgetToSimulator < ActiveRecord::Migration
  def change
    add_column :simulators, :initial_budget, :integer
  end
end
