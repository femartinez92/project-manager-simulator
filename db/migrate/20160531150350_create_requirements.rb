class CreateRequirements < ActiveRecord::Migration
  def change
    create_table :requirements do |t|
      t.string :requirement_id
      t.string :name
      t.string :description
      t.integer :project_id

      t.timestamps null: false
    end
  end
end
