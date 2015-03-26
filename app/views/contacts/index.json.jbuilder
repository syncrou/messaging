json.array!(@contacts) do |contact|
  json.extract! contact, :first_name, :last_name, :group_id, :email, :phone
  json.url contact_url(contact, format: :json)
end
