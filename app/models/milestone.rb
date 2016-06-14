# == Schema Information
#
# Table name: milestones
#
#  id                 :integer          not null, primary key
#  name               :string
#  description        :text
#  due_date           :date
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  project_id         :integer
#  is_admin_milestone :boolean
#  fake               :boolean
#  status             :string
#

class Milestone < ActiveRecord::Base
  has_many :tasks
  belongs_to :project

  scope :from_admin, -> { where(is_admin_milestone: true) }
  scope :no_fake,  -> { where(fake: false) }
  scope :not_aproved, -> {where.not(status: 'Aprobado')}
  scope :aproved, -> { where(status: 'Aprobado') }

  # Method for assigning a milestone to the task
  def add_task(task)
    task.milestone_id = id
    task.save
  end

  def ready?
    tasks.each do |task|
      return false if task.status != 'Finished'
    end
    true
  end

end
