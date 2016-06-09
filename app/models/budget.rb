class Budget < ActiveRecord::Base


  # This method return the total budget including the company
  # profit.
  def total
    activities_cost + activities_reserve + contingency_reserve +
      managment_reserve + profit
  end

  def data_for_stacked_column
    [
      {
        name: 'Disponible',
        data: [disp_act_cost, disp_act_res, disp_cont_res, disp_mng_res]
      },
      {
        name: 'Usado',
        data: [used_act_cost, used_act_res, used_cont_res, used_mng_res]
      }
    ]
  end

  def disp_act_cost
    self.activities_cost = 0 if self.activities_cost.nil?
    self.activities_cost_used = 0 if self.activities_cost_used.nil?
    save
    ['Costo de actividades', self.activities_cost - self.activities_cost_used]
  end

  def disp_act_res
    self.activities_reserve = 0 if self.activities_reserve.nil?
    self.activities_reserve_used = 0 if self.activities_reserve_used.nil?
    save
    ['Reserva de actividades', activities_reserve - activities_reserve_used]
  end

  def disp_cont_res
    self.contingency_reserve = 0 if self.contingency_reserve.nil? 
    self.contingency_reserve_used = 0 if self.contingency_reserve_used.nil?
    save
    ['Reserva de contingencia', contingency_reserve - contingency_reserve_used]
  end

  def disp_mng_res
    self.managment_reserve = 0 if self.managment_reserve.nil?
    self.managment_reserve_used = 0 if self.managment_reserve_used.nil?
    save
    ['Reserva de gestión', managment_reserve - managment_reserve_used]
  end

  def used_act_cost
    ['Costo de actividades', activities_cost_used]
  end

  def used_act_res
    ['Reserva de actividades', activities_reserve_used]
  end

  def used_cont_res
    ['Reserva de contingencia', contingency_reserve_used]
  end

  def used_mng_res
    ['Reserva de contingencia', contingency_reserve_used]
  end
  

end
