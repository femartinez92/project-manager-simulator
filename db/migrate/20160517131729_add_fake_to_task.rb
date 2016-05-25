class AddFakeToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :fake, :boolean
  end
end
