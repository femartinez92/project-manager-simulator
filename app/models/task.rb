class Task < ActiveRecord::Base
  resourcify
  belongs_to :milestone
  has_many :cost_lines
  has_many :resource_assignations
  has_many :human_resources, through: :resource_assignations

  scope :admin, -> { where(is_admin_task: true) }
  
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

end
