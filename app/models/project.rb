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

  def clone_requirements(other_project_id)
    requirements.each do |req|
      r2 = req.dup
      r2.project_id = other_project_id
      r2.save
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
