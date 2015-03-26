json.array!(@customers) do |customer|
  json.extract! customer, :name, :db_connection
  json.url customer_url(customer, format: :json)
end
