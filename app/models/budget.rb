class Budget < ActiveRecord::Base


  # This method return the total budget including the company
  # profit.
  def total
    activities_cost + activities_reserve + contingency_reserve +
      managment_reserve + profit
  end
end
