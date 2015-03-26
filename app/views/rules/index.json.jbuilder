json.array!(@rules) do |rule|
  json.extract! rule, :body, :customer_id, :name, :rule_type
  json.url rule_url(rule, format: :json)
end
