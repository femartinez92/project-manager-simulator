class Milestone < ActiveRecord::Base
  has_many :tasks

  # Method for assigning a milestone to the task
  def add_task(task)
    task.milestone_id = id
    task.save
  end
end
