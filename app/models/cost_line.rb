# == Schema Information
#
# Table name: cost_lines
#
#  id                   :integer          not null, primary key
#  name                 :string
#  description          :string
#  amount               :integer
#  real_amount          :integer
#  payment_week         :integer
#  real_payment_week    :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  cost_payment_plan_id :integer
#  status               :string
#  task_id              :integer
#  funding_source       :string
#

class CostLine < ActiveRecord::Base
  belongs_to :task
  belongs_to :cost_payment_plan

  # Scopes to get the paid and unpaid costs
  scope :paid, -> { where(status: 'Pagado') }
  scope :unpaid, -> { where(status: 'Pendiente') }

  scope :payment_week, ->(p_week) { where(payment_week: p_week) }

  def pay(r_am, r_pd)
    self.real_amount = r_am
    self.real_payment_week = r_pd
    self.status = 'Pagado'
    save
  end

  def paid?
    status == 'Pagado'
  end
end
