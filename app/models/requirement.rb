class Requirement < ActiveRecord::Base
  scope :present, -> { where(is_present: true) }

  def present?
    if is_present
      return 'presente'
    end
    'Aun no activo'
  end
end
