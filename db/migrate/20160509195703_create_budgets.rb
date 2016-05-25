class CreateBudgets < ActiveRecord::Migration
  def change
    create_table :budgets do |t|
      t.integer :project_id
      t.integer :activities_cost
      t.integer :activities_reserve
      t.integer :contingency_reserve
      t.integer :managment_reserve

      t.timestamps null: false
    end
  end
end
