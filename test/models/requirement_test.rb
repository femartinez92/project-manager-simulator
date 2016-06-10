# == Schema Information
#
# Table name: requirements
#
#  id             :integer          not null, primary key
#  requirement_id :string
#  name           :string
#  description    :string
#  project_id     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  is_present     :boolean
#

require 'test_helper'

class RequirementTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
