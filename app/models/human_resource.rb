class HumanResource < ActiveRecord::Base
  belongs_to :project
  has_many :resource_assignations
    has_many :tasks, through: :resource_assignations
  scope :from_admin, -> { where(is_from_admin: true)}


  def description
    name + ': ' + resource_type.to_s + ' | Sueldo: ' + salary.to_s +
      ' | Experiencia: ' + experience.to_s + ' años'
  end
end
