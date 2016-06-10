# == Schema Information
#
# Table name: human_resources
#
#  id            :integer          not null, primary key
#  name          :string
#  project_id    :integer
#  is_from_admin :boolean
#  experience    :integer
#  salary        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  resource_type :string
#  is_available  :boolean
#

require 'test_helper'

class HumanResourceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
