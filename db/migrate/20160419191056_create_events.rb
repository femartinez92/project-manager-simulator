class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.integer :subject_id
      t.string :subject_type

      t.timestamps null: false
    end
  end
end
