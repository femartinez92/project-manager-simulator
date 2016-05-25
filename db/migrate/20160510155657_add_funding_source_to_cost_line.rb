class AddFundingSourceToCostLine < ActiveRecord::Migration
  def change
    add_column :cost_lines, :funding_source, :string
  end
end
