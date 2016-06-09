class Milestone < ActiveRecord::Base
  has_many :tasks

  scope :from_admin, -> { where(is_admin_milestone: true) }
  scope :no_fake,  -> { where(fake: false) }
  scope :aproved, -> { where(status: 'Aprobado') }

  # Method for assigning a milestone to the task
  def add_task(task)
    task.milestone_id = id
    task.save
  end
end
