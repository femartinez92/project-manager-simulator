class AddStatusToCostLine < ActiveRecord::Migration
  def change
    add_column :cost_lines, :status, :string
  end
end
