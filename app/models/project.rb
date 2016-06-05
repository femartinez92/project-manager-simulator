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
    return true if (status == 'Inicio')
    false
  end

  def monitoriable?
    return true if ( status == 'Monitoreo y control' )
    false
  end

  def human_resources_for_select
    self.human_resources.map{|hr| [hr.name + ': ' + hr.resource_type.to_s + ' | Sueldo: ' + hr.salary.to_s + ' | Experiencia: ' + hr.experience.to_s + ' años', hr.id]}
  end

  def clone_requirements(other_project_id)
    self.requirements.each do |req|
      r2 = req.dup
      r2.project_id = other_project_id
      r2.save
    end
  end

end
