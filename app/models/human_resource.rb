# == Schema Information
#
# Table name: human_resources
#
#  id            :integer          not null, primary key
#  name          :string
#  project_id    :integer
#  is_from_admin :boolean
#  experience    :integer
#  salary        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  resource_type :string
#  is_available  :boolean
#

class HumanResource < ActiveRecord::Base

  # Human resources are related with a project
  belongs_to :project

  # Human resources are assigned to tasks
  has_many :resource_assignations
  has_many :tasks, through: :resource_assignations

  # This column determines if the human resource can be cloned
  # when you clone a project or if you are creating a new project
  scope :from_admin, -> { where(is_from_admin: true) }

  # This scopes shows wether the person is available or not
  scope :available, -> { where(is_available:  true) }
  scope :unavailable, -> { where(is_available: false) }

  # This method provides a way to show information of
  # the human resource. Actually used in the select box for
  # adding human resources to a task.
  def description
    name + ': ' + resource_type.to_s + ' | Sueldo: ' + salary.to_s +
      ' | Experiencia: ' + experience.to_s + ' años'
  end

  # Each human resource has a success probability,
  # based on the experience he/she has.
  # This is used to determine wether the task he is
  # working on will end on time or delayed.
  # If the employee has more than 5 years or experience, then 
  # the task will be done on the admin_duration_estimation.
  def probability_of_success
    experience / 5.0
  end
end
