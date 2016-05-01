class Task < ActiveRecord::Base
  resourcify
  belongs_to :milestone
  def add_milestone(milestone)
    self.milestone_id = milestone.id
    save
  end

end
