class CreatePrecedents < ActiveRecord::Migration
  def change
    create_table :precedents do |t|
      t.integer :predecessor_id
      t.integer :dependent_id

      t.timestamps null: false
    end
  end
end
