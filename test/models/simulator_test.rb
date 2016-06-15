# == Schema Information
#
# Table name: simulators
#
#  id                        :integer          not null, primary key
#  project_id                :integer
#  step_length               :integer
#  resource_unavailable_prob :decimal(, )
#  scope_modify_prob         :decimal(, )
#  risk_activation_prob      :decimal(, )
#  plan_change_prob          :decimal(, )
#  day                       :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  initial_budget            :integer
#  events_description        :text
#  original_duration         :integer
#  actual_duration           :integer
#

require 'test_helper'

class SimulatorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
