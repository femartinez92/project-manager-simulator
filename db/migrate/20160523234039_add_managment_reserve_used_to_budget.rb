class AddManagmentReserveUsedToBudget < ActiveRecord::Migration
  def change
    add_column :budgets, :managment_reserve_used, :integer
  end
end
