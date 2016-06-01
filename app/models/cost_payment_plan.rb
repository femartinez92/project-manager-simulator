class CostPaymentPlan < ActiveRecord::Base
  has_many :cost_lines

  def estimated_payment_schedule(project)
    ps ||= []
    start_date = project.start_date
    cls = self.cost_lines.group(:payment_week).sum(:amount)
    cls.each do |cl|
      unless (cl[0] == nil)
        am = cl[1]
        pd = start_date + cl[0].weeks
        ps << [pd.to_time, am]
      end
    end;
    ps
  end

  def real_payment_schedule(project)
    ps ||= []
    start_date = project.start_date
    cls = self.cost_lines.group(:real_payment_week).sum(:real_amount)
    cls.each do |cl|
      unless (cl[0] == nil)
        am = cl[1]
        pd = start_date + cl[0].weeks
        ps << [pd.to_time, am]
      end
    end;
    ps
  end

end
