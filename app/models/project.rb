class Project < ActiveRecord::Base
  has_many :milestones
  has_one :cost_payment_plan
  has_many :stakeholders
  has_one :budget
  has_many :requirements

  scope :from_admin, -> { where(is_admin_project: true) }
  scope :cloned, -> { where(is_admin_project: false) }

  def modificable?
    return true if status == 'Inicio'
    false
  end

end
