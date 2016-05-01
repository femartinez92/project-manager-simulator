class AddProjectIdToCostPaymentPlan < ActiveRecord::Migration
  def change
    add_column :cost_payment_plans, :project_id, :integer
  end
end
