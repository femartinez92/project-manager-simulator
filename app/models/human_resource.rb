class HumanResource < ActiveRecord::Base
	belongs_to :project
	scope :from_admin, -> { where(is_from_admin: true)}
end
