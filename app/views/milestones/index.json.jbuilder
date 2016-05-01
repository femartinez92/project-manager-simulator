json.array!(@milestones) do |milestone|
  json.extract! milestone, :id, :name, :description, :due_date
  json.url milestone_url(milestone, format: :json)
end
