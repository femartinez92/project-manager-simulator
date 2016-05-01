json.array!(@projects) do |project|
  json.extract! project, :id, :name, :actual_date, :budget
  json.url project_url(project, format: :json)
end
