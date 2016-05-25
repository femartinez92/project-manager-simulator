class Stakeholder < ActiveRecord::Base
  belongs_to :project

  def increase_commitment
    if self.commitment_level < 5
      self.commitment_level += 1
      if save
        true
      else
        false
      end
    else
      false
    end
  end
end
