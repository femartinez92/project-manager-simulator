class CreateCostLines < ActiveRecord::Migration
  def change
    create_table :cost_lines do |t|
      t.string :name
      t.string :description
      t.integer :amount
      t.date :payment_date

      t.timestamps null: false
    end
  end
end
