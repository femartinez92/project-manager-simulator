json.array!(@stakeholders) do |stakeholder|
  json.extract! stakeholder, :id, :name, :commitment_level, :influence, :power
  json.url stakeholder_url(stakeholder, format: :json)
end
