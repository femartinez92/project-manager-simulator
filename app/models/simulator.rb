class Simulator < ActiveRecord::Base
  belongs_to :project

  def win?
    Project.find(project_id).win?
  end

  # This method is to check the initial conditions 
  # to start the simulation
  def start_prevalidation(project)
    # Verify all tasks have estimated duration
    @project.milestones.each do |mile|
      mile.tasks.each do |task|
        return false if !task.estimated?
      end
    end

  end

  def clone
    s2 = self.dup
    s2.save
  end

end
