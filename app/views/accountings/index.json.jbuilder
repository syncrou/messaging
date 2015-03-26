json.array!(@accountings) do |accounting|
  json.extract! accounting, :customer_id, :invoiced, :paid
  json.url accounting_url(accounting, format: :json)
end
