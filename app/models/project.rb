# == Schema Information
#
# Table name: projects
#
#  id                  :integer          not null, primary key
#  name                :string
#  actual_week         :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  project_manager_id  :integer
#  status              :string
#  is_admin_project    :boolean
#  start_date          :date
#  strategic_objective :text
#

class Project < ActiveRecord::Base
  has_many :milestones
  has_one :cost_payment_plan
  has_many :stakeholders
  has_one :budget
  has_many :requirements
  has_many :human_resources
  has_one :simulator

  scope :from_admin, -> { where(is_admin_project: true) }
  scope :cloned, -> { where(is_admin_project: false) }

  def modificable?
    return true if (status == 'Inicio')
    false
  end

  def monitoriable?
    return true if (status == 'Monitoreo y control')
    false
  end

  def human_resources_for_select
    human_resources.map { |hr| [hr.description, hr.id] }
  end

  def tasks_for_timeline
    tasks_f_time ||= []
    milestones.each do |mile|
      mile.tasks.each do |task|
        task.update(start_date: start_date) if task.start_date.nil?
        task.update(end_date: task.start_date + task.pm_duration_estimation.days) if task.end_date.nil?
        tasks_f_time << [task.name + ' | '+ mile.id.to_s, task.start_date, task.end_date]
      end
    end
    p tasks_f_time
  end

  def tasks
    tasks ||= []
    milestones.each do |mile|
      mile.tasks.each do |task|
        tasks << task
      end
    end
    tasks
  end

  # Clone all the elements and params of the original project to
  # the new one
  def clone_characteristics_from(original_project, current_project_manager)
    # Create a new cost payment plan for this project
    cpp = CostPaymentPlan.create!
    self.cost_payment_plan = cpp
    clone_budget_from(original_project)
    clone_requirements_from(original_project)
    clone_stakeholders_from(original_project)
    self.simulator = original_project.simulator.clone
    self.project_manager_id = current_project_manager.id
    self.is_admin_project = current_project_manager.has_role? :admin
    self.status = 'Inicio'
    save
  end

  def clone_budget_from(original_project)
    self.budget = original_project.budget.dup
    save
  end

  # Clone the requirements of the project
  def clone_requirements_from(original_project)
    original_project.requirements.each do |req|
      r2 = req.dup
      r2.attributes = { project_id: id }
      r2.save
    end
  end

  # Clone the stakeholders
  def clone_stakeholders_from(original_project)
    original_project.stakeholders.each do |stakeholder|
      sh2 = stakeholder.dup
      sh2.attributes =  { project_id: id, is_admin_stakeholder: false }
      sh2.save
    end
  end

  # ---- Methods for simulation ---- #

  # To win the game the project must be completed,
  # in order to do that all the milestones should be finished
  def win?
    milestones.each do |mile|
      return false unless mile.status = 'Finished'
    end
    true
  end

  # To loose the game 1 of 3 conditions mus occur:
  # => Project expenses consume the profit of the project
  # => Cost for the client increases in 25%
  # => There is a delay of more than 25%
  def loose?
    return true if budget.total - cost_payment_plan.total <= 0
  end

end
