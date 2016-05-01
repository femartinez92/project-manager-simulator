class CreateMilestones < ActiveRecord::Migration
  def change
    create_table :milestones do |t|
      t.string :name
      t.text :description
      t.date :due_date

      t.timestamps null: false
    end
  end
end
