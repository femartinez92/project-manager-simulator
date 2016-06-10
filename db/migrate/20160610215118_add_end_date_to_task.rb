class AddEndDateToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :end_date, :date
  end
end
