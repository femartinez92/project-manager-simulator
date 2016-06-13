# == Schema Information
#
# Table name: precedents
#
#  id             :integer          not null, primary key
#  predecessor_id :integer
#  dependent_id   :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  project_id     :integer
#

class Precedent < ActiveRecord::Base 
  after_create :update_dependent_task_dates

  def update_dependent_task_dates
    predecessor_end_date = Task.find(predecessor_id).end_date
    dependent_task = Task.find(dependent_id)
    dependent_task.update_start_date(predecessor_end_date)
  end
end
