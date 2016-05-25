class AddProfitToBudget < ActiveRecord::Migration
  def change
    add_column :budgets, :profit, :integer
  end
end
