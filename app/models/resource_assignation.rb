class ResourceAssignation < ActiveRecord::Base
	belongs_to :human_resource
	belongs_to :task
end
