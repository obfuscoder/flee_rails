json.array!(@reservations) do |reservation|
  json.extract! reservation, :id, :seller_id, :event_id, :number
  json.url reservation_url(reservation, format: :json)
end
