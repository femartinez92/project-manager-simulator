# == Schema Information
#
# Table name: resource_assignations
#
#  id                :integer          not null, primary key
#  human_resource_id :integer
#  task_id           :integer
#  time              :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'test_helper'

class ResourceAssignationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
