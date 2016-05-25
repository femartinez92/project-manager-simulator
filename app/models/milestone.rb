class Milestone < ActiveRecord::Base
  has_many :tasks

  scope :from_admin, -> { where(is_admin_milestone: true) }

  # Method for assigning a milestone to the task
  def add_task(task)
    task.milestone_id = id
    task.save
  end
end
