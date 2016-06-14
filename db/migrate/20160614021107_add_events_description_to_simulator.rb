class AddEventsDescriptionToSimulator < ActiveRecord::Migration
  def change
    add_column :simulators, :events_description, :text
  end
end
