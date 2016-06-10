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

class ResourceAssignation < ActiveRecord::Base
	belongs_to :human_resource
	belongs_to :task
end
