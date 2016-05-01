json.array!(@tasks) do |task|
  json.extract! task, :id, :name, :description, :min_duration, :most_probable_duration, :max_duration, :pm_duration_estimation
  json.url task_url(task, format: :json)
end
