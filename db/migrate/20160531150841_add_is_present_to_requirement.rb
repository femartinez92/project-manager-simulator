class AddIsPresentToRequirement < ActiveRecord::Migration
  def change
    add_column :requirements, :is_present, :boolean
  end
end
