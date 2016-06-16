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
  has_many :milestones, dependent: :destroy
  has_one :cost_payment_plan, dependent: :destroy
  has_many :stakeholders, dependent: :destroy
  has_one :budget, dependent: :destroy
  has_many :requirements, dependent: :destroy
  has_many :human_resources, dependent: :destroy
  has_one :simulator, dependent: :destroy

  scope :from_admin, -> { where(is_admin_project: true) }
  scope :cloned, -> { where(is_admin_project: false) }

  def modificable?
    return true if (status == 'Inicio')
    false
  end

  def monitorable?
    return true if (status == 'Monitoreo y control')
    false
  end

  def human_resources_for_select
    human_resources.map { |hr| [hr.description, hr.id] }
  end

  # This method returns the duration of the project in days
  def duration
    e_date = start_date
    all_tasks.each do |task|
      e_date = task.end_date if task.end_date > e_date
    end
    (e_date - start_date).to_i
  end

  # This method cares of paying the salaries, it verifies that it hasn't
  # been paid earlier this week.
  # It's funded by the activities reserve
  def pay_salaries(week)
    cpp = cost_payment_plan
    human_resources.each do |hr|
      nyd = 'Pago sueldo ' + hr.name
      am = hr.salary
      unless CostLine.where(name: nyd, payment_week: week).length > 0
        cl = CostLine.new(name: nyd, description: nyd,
                          amount: am, real_amount: am,
                          payment_week: week, real_payment_week: week,
                          cost_payment_plan_id: cpp.id, status: 'Pagado',
                          funding_source: 'Reserva de actividades')
        cl.save
        use_budget(cl)
      end
    end
  end

  # Method used to increase the used amount of the budget
  def use_budget(cost_line)
    bud = budget
    case cost_line.funding_source
    when 'Costo de actividades'
      bud.activities_cost_used += cost_line.real_amount
    when 'Reserva de actividades'
      bud.activities_reserve_used += cost_line.real_amount
    when 'Reserva de contingencias'
      bud.contingency_reserve_used += cost_line.real_amount
    when 'Reserva de gestión'
      bud.managment_reserve_used += cost_line.real_amount
    end
    bud.save 
  end

  # This method return an array of the project tasks with columns
  # [:name, :start_date, :end_date]
  def tasks_for_timeline
    tasks_f_time ||= []
    milestones.each do |mile|
      mile.tasks.each do |task|
        task.update(start_date: start_date) if task.start_date.nil?
        task.update(end_date: task.start_date + task.pm_duration_estimation.days) if task.end_date.nil?
        tasks_f_time << [task.name + ' | ' + mile.name + ' | ' + task.advance_percentage.to_s + "% ", task.start_date, task.end_date]
      end
    end
    tasks_f_time
  end

  def all_tasks
    tasks ||= []
    milestones.each do |mile|
      mile.tasks.each do |task|
        tasks << task
      end
    end
    tasks
  end

  def active_tasks
    tasks ||= []
    milestones.each do |mile|
      mile.tasks.active.each do |task|
        tasks << task
      end
    end
    tasks
  end

  def waiting_tasks
    tasks ||= []
    milestones.each do |mile|
      mile.tasks.waiting.each do |task|
        tasks << task
      end
    end
    tasks
  end

  def finished_tasks
    tasks ||= []
    milestones.each do |mile|
      mile.tasks.finished.each do |task|
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
      return false unless mile.status == 'Aprobado'
    end
    true
  end

  # To loose the game 1 of 3 conditions mus occur:
  # => Project expenses consume the profit of the project
  # => Cost for the client increases in 25%
  # => There is a delay of more than 25%
  def loose?
    return true if budget.actual_earnings < 0
    return true if simulator.initial_budget and budget.total_used > 1.25 * simulator.initial_budget
    return true if simulator.actual_duration and simulator.actual_duration > 1.25 * simulator.original_duration
    return true if simulator.day and simulator.day > simulator.actual_duration
    false
  end

  # This method is for restarting thr project
  def restart
    budget.restart
    cost_payment_plan.restart
    self.update(actual_week: 0, status: 'Inicio')
    milestones.map { |mile| mile.restart }
  end
end
