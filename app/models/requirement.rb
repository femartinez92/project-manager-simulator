# == Schema Information
#
# Table name: requirements
#
#  id             :integer          not null, primary key
#  requirement_id :string
#  name           :string
#  description    :string
#  project_id     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  is_present     :boolean
#

class Requirement < ActiveRecord::Base
  scope :present, -> { where(is_present: true) }

  def present?
    if is_present
      return 'Presente'
    end
    'Aun no activo'
  end

  def print
  	requirement_id + ' | ' +  name + ' | ' + present? + " | " + description
  end
end
