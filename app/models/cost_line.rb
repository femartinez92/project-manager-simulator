class CostLine < ActiveRecord::Base
  belongs_to :task
  belongs_to :cost_payment_plan

  # Scopes to get the paid and unpaid costs
  scope :paid, -> { where(status: 'Pagado') }
  scope :unpaid, -> { where(status: 'Pendiente') }

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
