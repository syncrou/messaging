json.array!(@controls) do |control|
  json.extract! control, :customer_id, :name, :twilio_api
  json.url control_url(control, format: :json)
end
