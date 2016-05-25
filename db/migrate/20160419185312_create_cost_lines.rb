class CreateCostLines < ActiveRecord::Migration
  def change
    create_table :cost_lines do |t|
      t.string :name
      t.string :description
      t.integer :amount
      t.integer :real_amount
      t.integer :payment_week
      t.integer :real_payment_week

      t.timestamps null: false
    end
  end
end
