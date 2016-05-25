class AddIsAdminStakeholderToStakeholder < ActiveRecord::Migration
  def change
    add_column :stakeholders, :is_admin_stakeholder, :boolean
  end
end
