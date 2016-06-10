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

require 'test_helper'

class StakeholderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
