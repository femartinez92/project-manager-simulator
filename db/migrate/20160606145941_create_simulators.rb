class CreateSimulators < ActiveRecord::Migration
  def change
    create_table :simulators do |t|
      t.integer :project_id
      t.integer :step_length
      t.decimal :resource_unavailable_prob
      t.decimal :scope_modify_prob
      t.decimal :risk_activation_prob
      t.decimal :plan_change_prob
      t.integer :day

      t.timestamps null: false
    end
  end
end
