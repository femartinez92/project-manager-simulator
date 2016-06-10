# == Schema Information
#
# Table name: tasks
#
#  id                        :integer          not null, primary key
#  name                      :string
#  description               :text
#  min_duration              :integer
#  most_probable_duration    :integer
#  max_duration              :integer
#  pm_duration_estimation    :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  milestone_id              :integer
#  is_admin_task             :boolean
#  fake                      :boolean
#  admin_duration_estimation :integer
#  advance_percentage        :integer
#  status                    :string
#

require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
