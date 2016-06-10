# == Schema Information
#
# Table name: milestones
#
#  id                 :integer          not null, primary key
#  name               :string
#  description        :text
#  due_date           :date
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  project_id         :integer
#  is_admin_milestone :boolean
#  fake               :boolean
#  status             :string
#

require 'test_helper'

class MilestoneTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
