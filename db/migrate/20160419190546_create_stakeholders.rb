class CreateStakeholders < ActiveRecord::Migration
  def change
    create_table :stakeholders do |t|
      t.string :name
      t.integer :commitment_level
      t.integer :influence
      t.integer :power

      t.timestamps null: false
    end
  end
end
