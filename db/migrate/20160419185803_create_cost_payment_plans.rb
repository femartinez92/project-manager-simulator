class CreateCostPaymentPlans < ActiveRecord::Migration
  def change
    create_table :cost_payment_plans do |t|

      t.timestamps null: false
    end
  end
end
