class AddIsAvailableToHumanResource < ActiveRecord::Migration
  def change
    add_column :human_resources, :is_available, :boolean
  end
end
