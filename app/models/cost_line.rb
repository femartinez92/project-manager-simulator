class CostLine < ActiveRecord::Base
	belongs_to :task
	belongs_to :cost_payment_plan
end
