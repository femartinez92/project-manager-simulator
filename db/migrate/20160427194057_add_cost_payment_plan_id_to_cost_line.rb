class AddCostPaymentPlanIdToCostLine < ActiveRecord::Migration
  def change
    add_column :cost_lines, :cost_payment_plan_id, :integer
  end
end
