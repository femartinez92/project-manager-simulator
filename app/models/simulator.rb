class Simulator < ActiveRecord::Base
  belongs_to :project

  def win?
    Project.find(project_id).win?
  end


end
