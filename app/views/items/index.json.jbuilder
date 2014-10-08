json.array!(@items) do |item|
  json.extract! item, :id, :seller_id, :description, :size, :price
  json.url item_url(item, format: :json)
end
