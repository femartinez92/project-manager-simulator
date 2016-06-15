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
  has_many :tasks, dependent: :destroy
  belongs_to :project

  scope :from_admin, -> { where(is_admin_milestone: true) }
  scope :no_fake,  -> { where(fake: false) }
  scope :not_aproved, -> { where("milestones.status != 'Aprobado' OR milestones.status IS NULL ") }
  scope :aproved, -> { where(status: 'Aprobado') }

  # Method for assigning a milestone to the task
  def add_task(task)
    task.milestone_id = id
    task.save
  end

  def ready?
    tasks.each do |task|
      p task.status
      return false if task.status != 'Terminada'
    end
    true
  end

  def restart
    tasks.map { |task| task.restart }
    update(status: 'No aprobado')
  end

end
