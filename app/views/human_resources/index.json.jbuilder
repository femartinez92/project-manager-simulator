json.array!(@human_resources) do |human_resource|
  json.extract! human_resource, :id, :name, :project_id, :is_from_admin, :experience, :salary
  json.url human_resource_url(human_resource, format: :json)
end
