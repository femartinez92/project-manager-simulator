class Project < ActiveRecord::Base
  has_many :milestones
  has_one :cost_payment_plan
  has_many :stakeholders

end
