json.array!(@events) do |event|
  json.extract! event, :id, :name, :details, :max_sellers, :max_items_per_seller, :confirmed
  json.url event_url(event, format: :json)
end
