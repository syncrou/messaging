json.array!(@deliverables) do |deliverable|
  json.extract! deliverable, 
  json.url deliverable_url(deliverable, format: :json)
end
