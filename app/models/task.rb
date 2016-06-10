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

end
