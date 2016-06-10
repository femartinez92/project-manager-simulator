# == Schema Information
#
# Table name: simulators
#
#  id                        :integer          not null, primary key
#  project_id                :integer
#  step_length               :integer
#  resource_unavailable_prob :decimal(, )
#  scope_modify_prob         :decimal(, )
#  risk_activation_prob      :decimal(, )
#  plan_change_prob          :decimal(, )
#  day                       :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

class Simulator < ActiveRecord::Base
  belongs_to :project

  def win?
    Project.find(project_id).win?
  end

  def execute_step
    r = Random.new
    r.rand
    raise "exception"
  end

  # This method is to check the initial conditions 
  # to start the simulation
  # => All no fake milestones and tasks should be in the project
  # => All tasks must have a pm_estimation duration
  # => All tasks must have assigned resources to be developed
  def prevalidate
    project = Project.find(project_id)
    parent_project = Project.from_admin.where(name: project.name).first
    possible_milestones = parent_project.milestones
    milestones = project.milestones
    missing_imp_miles = possible_milestones.no_fake.length > milestones.no_fake.length
    return 'Hay hitos importantes no agregados' if missing_imp_miles
    milestones.each do |mile|
      pos_mile = possible_milestones.where(name: mile.name).first
      possible_tasks = pos_mile.tasks.no_fake
      tasks = mile.tasks
      missing_imp_tasks = possible_tasks.length > tasks.no_fake.length
      return 'Hay tareas importantes no se han agregadas' if missing_imp_tasks
      tasks.each do |task|
        return 'Te falta estimar la duración de 1 o más tareas para poder comenzar' if !task.estimated?
        return 'Algunas tareas no tienen suficientes recursos humanos' if task.resource_assignations.sum(:time) < task.pm_duration_estimation
      end
    end
    'Ya puedes comenzar la simulación'
  end

  def can_start?
    return true if prevalidate == 'Ya puedes comenzar la simulación'
    false
  end

  def negotiate(type, options = {})
    case type
    when 'increase_budget'
      options[:amount]
    when 'increase_deadline'
      options[:task_id]
    when 'change_requirement'
      options[:add_requirement_id]
      options[:delete_requirement_id]
    end
  end

  def clone
    s2 = self.dup
    s2.save
    s2
  end

end
