class CostPaymentPlan < ActiveRecord::Base
	has_many :cost_lines
end
