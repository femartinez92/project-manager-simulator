json.array!(@cost_payment_plans) do |cost_payment_plan|
  json.extract! cost_payment_plan, :id
  json.url cost_payment_plan_url(cost_payment_plan, format: :json)
end
