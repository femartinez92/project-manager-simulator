class AddContingencyReserveUsedToBudget < ActiveRecord::Migration
  def change
    add_column :budgets, :contingency_reserve_used, :integer
  end
end
