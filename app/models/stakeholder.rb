# == Schema Information
#
# Table name: stakeholders
#
#  id                   :integer          not null, primary key
#  name                 :string
#  commitment_level     :integer
#  influence            :integer
#  power                :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  project_id           :integer
#  is_admin_stakeholder :boolean
#

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
