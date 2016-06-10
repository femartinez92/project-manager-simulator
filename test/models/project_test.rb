# == Schema Information
#
# Table name: projects
#
#  id                  :integer          not null, primary key
#  name                :string
#  actual_week         :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  project_manager_id  :integer
#  status              :string
#  is_admin_project    :boolean
#  start_date          :date
#  strategic_objective :text
#

require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
