class AddResourceTypeToHumanResource < ActiveRecord::Migration
  def change
    add_column :human_resources, :resource_type, :string
  end
end
