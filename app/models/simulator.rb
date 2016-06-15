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
#  initial_budget            :integer
#  events_description        :text
#  original_duration         :integer
#  actual_duration           :integer
#

class Simulator < ActiveRecord::Base
  belongs_to :project

  def win?
    project.win?
  end

  def execute_step
    project.update(status: 'Ejecución')
    self.day ||= -1
    self.initial_budget ||= project.budget.total
    self.original_duration ||= project.duration
    self.actual_duration ||= project.duration
    self.events_description ||= ''
    save
    hhrr = project.human_resources
    hhrr.update_all(is_available: true)
    ran = g_random(0,hhrr.length - 1)
    
    # Generate events
    self.events_description += "EVENTOS \r\n"
    if generate_random <= resource_unavailable_prob
      hhrr[ran].update(is_available: false)
      self.events_description += "El empleado #{ hhrr[ran].name }, se ha reportado enfermo \r\n"
    end
    if generate_random <= scope_modify_prob
      req = project.requirements.not_present.first
      req.update(is_present: true) unless req.nil?
      self.events_description += "Se debe agregar el requisito #{ req.name }\r\n" unless req.nil?
    end
    if generate_random <= plan_change_prob
      a_tasks = project.active_tasks
      if a_tasks.length > 0
        ran2 = g_random(0, a_tasks.length - 1)
        n_days = g_random(1, 4)
        a_tasks[ran2].update_end_date(n_days)
        self.events_description += "Se ha atrasado la tarea #{ a_tasks[ran2].name } en #{n_days} días\r\n"
      end
    end
    if generate_random <= risk_activation_prob
      n_days  = g_random(2, 4)
      activate_risk(n_days)
      self.events_description += "Se ha activado un riesgo, todas las tareas en ejecución se atrasan #{n_days} días\r\n"
    end

    # Advance days of the step
    1.upto(step_length) do |i|
      self.update(day: day + 1)
      self.events_description += "DIA #{day} \r\n"
      actual_date = project.start_date + day.days
      week = (day/7.0).ceil
      # Update the week of the project
      project.update(actual_week: week) if project.actual_week != week
      # Advance active tasks and today starting tasks
      project.active_tasks.each do |task|
        task.advance(1)
      end
      project.waiting_tasks.each do |task|
        task.advance(1) if task.start_date == actual_date
      end
      # Aprove milestones if needed
      project.milestones.not_aproved.each do |mile|
        if mile.ready?
          p 'Ready'
          mile.update(status: 'Aprobado')
          self.events_description += "Se ha aprobado el hito: #{mile.name}\r\n"
        end
      end
      # Pay costs & salaries
      cpp = project.cost_payment_plan
      cpp.cost_lines.unpaid.payment_week(week).each do |cl|
        cl.pay(cl.amount, week)
        project.use_budget(cl)
      end
      project.pay_salaries(week) if week%4 == 0 and week%52 != 0
      # Employee returns to work with probability 0.5
      if generate_random < 0.5
        self.events_description += "El empleado #{ hhrr[ran].name }, ha vuelto a trabajar\r\n" unless hhrr[ran].is_available
        hhrr[ran].update(is_available: true)
      end
    end
    project.update(status: 'Monitoreo y control')
    self.save
  end

  
  # Method for generating random numbers
  def generate_random
    r = Random.new
    r.rand
  end

  def g_random(a, b)
    r = Random.new
    r.rand(a..b)
  end

  # Method for activating a risk in the project
  def activate_risk(n_days)
    project.active_tasks.map{ |a_task| a_task.update_end_date(n_days) }
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
      return 'Hay tareas importantes no agregadas' if missing_imp_tasks
      tasks.each do |task|
        return 'Te falta estimar la duración de 1 o más tareas para poder comenzar' if !task.estimated?
        return 'Algunas tareas no tienen suficientes recursos humanos' if task.resource_assignations.sum(:time) < task.pm_duration_estimation
      end
    end
    'Ya puedes comenzar la simulación'
  end

  def restart_simulation
    self.day = nil
    self.events_description = ''
    self.save
    project.restart
  end
  # This method determines wether the user can start the simulation
  def can_start?
    return true if prevalidate == 'Ya puedes comenzar la simulación'
    false
  end

  # This method controls the negotiation logic
  def negotiate(type, options = {})
    case type
    when 'increase_budget'
      project.budget.increase(options[:amount])
      return "Se ha aceptado el aumento de presupuesto " + options[:message]
    when 'increase_deadline'
      actual_duration.update(actual_duration + options[:days])
      return "Se ha aceptado la extensión de plazo"
    when 'change_requirement'
      Requirement.find(options[:add_requirement_id]).update(is_present: true)
      Requirement.find(options[:delete_requirement_id]).update(is_present: false)
      return "Se ha aceptado el cambio de requerimientos"
    end
  end

  def clone
    s2 = self.dup
    s2.save
    s2
  end

end
