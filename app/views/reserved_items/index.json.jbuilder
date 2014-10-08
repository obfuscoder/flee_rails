json.array!(@reserved_items) do |reserved_item|
  json.extract! reserved_item, :id, :reservation_id, :item_id, :number, :code, :sold
  json.url reserved_item_url(reserved_item, format: :json)
end
