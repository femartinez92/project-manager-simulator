class Task < ActiveRecord::Base
  resourcify
  belongs_to :milestone
  has_many :cost_lines
  scope :admin, -> { where(is_admin_task: true) } 
  
  def add_milestone(milestone)
    self.milestone_id = milestone.id
    save
  end

end
