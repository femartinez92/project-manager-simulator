# == Schema Information
#
# Table name: cost_lines
#
#  id                   :integer          not null, primary key
#  name                 :string
#  description          :string
#  amount               :integer
#  real_amount          :integer
#  payment_week         :integer
#  real_payment_week    :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  cost_payment_plan_id :integer
#  status               :string
#  task_id              :integer
#  funding_source       :string
#

require 'test_helper'

class CostLineTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
