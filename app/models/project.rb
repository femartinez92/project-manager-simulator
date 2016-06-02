class Project < ActiveRecord::Base
  has_many :milestones
  has_one :cost_payment_plan
  has_many :stakeholders
  has_one :budget
  has_many :requirements
  has_many :human_resources

  scope :from_admin, -> { where(is_admin_project: true) }
  scope :cloned, -> { where(is_admin_project: false) }

  def modificable?
    return true if status == 'Inicio'
    false
  end

  def clone_requirements(other_project_id)
    self.requirements.each do |req|
      r2 = req.dup
      r2.project_id = other_project_id
      r2.save
    end
  end

end
