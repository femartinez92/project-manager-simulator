class Simulator < ActiveRecord::Base
  belongs_to :project

  def win?
    Project.find(project_id).win?
  end

  def execute_step
    r = Random.new
    r.rand
  end

  # This method is to check the initial conditions 
  # to start the simulation
  # => All no fake milestones and tasks should be in the project
  # => All tasks must have a pm_estimation duration
  # => All tasks must have assigned resources to be developed
  def prevalidate
    project = Project.find(project_id)
    parent_project = Project.from_admin.where(name: project.name).first
    possible_milestones = parent_project.milestones.no_fake
    milestones = project.milestones
    possible_milestones.each do |pos_mile|
      mile = milestones.where(name: pos_mile.name)
      return 'Hay hitos importantes no agregados' if (mile.length == 0)
      possible_tasks = pos_mile.tasks.no_fake
      tasks = mile.first.tasks
      possible_tasks.each do |pos_task|
        task = tasks.where(name: pos_task.name)
        return 'Hay tareas importantes que aun no se han agregado' if (task.length == 0)
        return 'Te falta estimar la duración de 1 o más tareas para poder comenzar' if !task.first.estimated?
        return 'Algunas tareas no tienen suficientes recursos humanos' if task.first.resource_assignations.sum(:time) < task.first.pm_duration_estimation
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
