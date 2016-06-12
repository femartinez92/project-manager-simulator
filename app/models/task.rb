# == Schema Information
#
# Table name: tasks
#
#  id                        :integer          not null, primary key
#  name                      :string
#  description               :text
#  min_duration              :integer
#  most_probable_duration    :integer
#  max_duration              :integer
#  pm_duration_estimation    :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  milestone_id              :integer
#  is_admin_task             :boolean
#  fake                      :boolean
#  admin_duration_estimation :integer
#  advance_percentage        :integer
#  status                    :string
#  start_date                :date
#  end_date                  :date
#

class Task < ActiveRecord::Base
  resourcify
  belongs_to :milestone
  has_many :cost_lines
  has_many :resource_assignations
  has_many :human_resources, through: :resource_assignations

  scope :admin, -> { where(is_admin_task: true) }
  scope :no_fake, -> { where(fake: false) }
  scope :finished, -> { where(status: 'Terminada') }
  
  def add_milestone(milestone)
    self.milestone_id = milestone.id
    save
  end

  # Vemos si ya se estimo la duracion de la tarea

  def estimated?
    return false if pm_duration_estimation.nil?
    true
  end

  def advance(percentage)
    return false unless advance_percentage.nil?
    return false if advance_percentage < percentage
    self.advance_percentage = percentage
    save
  end

  def clone_costs(other_task_id, cpp_id)
    cost_lines.each do |cost_line|
      cl = cost_line.dup
      cl.task_id = other_task_id
      cl.cost_payment_plan_id = cpp_id
      cl.save
    end
  end

  def update_start_date
    task_ids_precedent = Precedent.select(:predecessor_id).where(dependent_id: self.id)
    start_date = latest_end_date(task_ids_precedent)
    update_end_date
  end

  def update_end_date
    if end_date != start_date + pm_duration_estimation.days
      end_date = start_date + pm_duration_estimation.days
      update_dependent_dates(end_date)
    end
  end

  def latest_end_date(task_ids_precedent)
    # e_date = self.milestone.project.start_date
    task_ids_precedent.reduce(pjct_start_date) { |e_date, task_id| Task.find(task_id).end_date}
    task_ids_precedent.each do |task_id|
      task = Task.find(task_id)
      e_date = task.end_date unless task.end_date < e_date and task.end_date.nil?
    end
  end

  def pjct_start_date
    self.milestone.project.start_date
  end

  def update_dependent_dates(end_date)
    task_ids_dependents = Precedent.select(:dependent_id).where(predecessor_id: self.id)
  end

end
