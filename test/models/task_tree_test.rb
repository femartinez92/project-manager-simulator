# == Schema Information
#
# Table name: task_trees
#
#  id         :integer          not null, primary key
#  father_id  :integer
#  child_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class TaskTreeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
