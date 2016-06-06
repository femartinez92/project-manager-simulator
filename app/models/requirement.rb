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
