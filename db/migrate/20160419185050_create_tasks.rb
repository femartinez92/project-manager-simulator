class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.integer :min_duration
      t.integer :most_probable_duration
      t.integer :max_duration
      t.integer :pm_duration_estimation

      t.timestamps null: false
    end
  end
end
