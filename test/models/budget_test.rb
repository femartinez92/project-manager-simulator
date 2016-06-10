# == Schema Information
#
# Table name: budgets
#
#  id                       :integer          not null, primary key
#  project_id               :integer
#  activities_cost          :integer
#  activities_reserve       :integer
#  contingency_reserve      :integer
#  managment_reserve        :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  profit                   :integer
#  activities_cost_used     :integer
#  activities_reserve_used  :integer
#  contingency_reserve_used :integer
#  managment_reserve_used   :integer
#

require 'test_helper'

class BudgetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
