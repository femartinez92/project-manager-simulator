# == Schema Information
#
# Table name: precedents
#
#  id             :integer          not null, primary key
#  predecessor_id :integer
#  dependent_id   :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  project_id     :integer
#

require 'test_helper'

class PrecedentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
