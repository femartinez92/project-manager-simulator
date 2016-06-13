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
  scope :unfinished, -> { where.not(status: 'Terminada') }
  
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

  ##########################################
  #### --- Advance and delay tasks --- #####
  ##########################################
  def delay_start(s_date)
    return false if start_date >= s_date
    self.start_date = s_date
    save
  end

  def delay_end(e_date)
    return false if end_date >= e_date
    self.end_date = e_date
    save
  end

  def advance_start(s_date)
    return false if start_date <= s_date
    self.start_date = s_date
    save
  end

  def advance_end(e_date)
    return false if end_date <= e_date
    self.end_date = e_date
    save
  end

  ############################################
  #### --- Advance and delays control --- ####
  ############################################

  # This method is used when a new precedent relation is created or a task 
  # with dependents is delayed
  def update_start_date(s_date)
    if delay_start(s_date)
      if delay_end(start_date + pm_duration_estimation)
        dependent_tasks_id = Precedent.select(:dependent_id).where(predecessor_id: id)
        dependent_tasks_id.each do |t_id|
          Task.find(t_id).update_start_date(end_date)
        end
      end
    end
  end

  # This method is used when the simulation determines that the task 
  # ends later than it was supposed 
  # @ds : days of delay, if negative => advance (not implemented yet)
  def update_end_date(ds)
    if delay_end(end_date + ds.days)
      dependent_tasks_id = Precedent.select(:dependent_id).where(predecessor_id: id)
      dependent_tasks_id.each do |t_id|
        Task.find(t_id).update_start_date(end_date)
      end
    # else 
    #   if advance(end_date + ds.days)
    #     dependent_tasks_id = Precedent.select(:dependent_id).where(predecessor_id: id)
    #     dependent_tasks_id.each do |t_id|
    #       t = Task.find(t_id)
    #     end
    #   end
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
    milestone.project.start_date
  end

  def delay_dependent_dates(end_date)
    task_ids_dependents = Precedent.select(:dependent_id).where(predecessor_id: id)
  end

end
