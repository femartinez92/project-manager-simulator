class HumanResource < ActiveRecord::Base
  belongs_to :project
  has_many :resource_assignations
    has_many :tasks, through: :resource_assignations
  scope :from_admin, -> { where(is_from_admin: true)}

  def description
    self.name + ": " + self.resource_type.to_s
  end
end
