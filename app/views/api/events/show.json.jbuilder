json.call(@event, :id, :name, :price_precision, :commission_rate, :seller_fee, :donation_of_unsold_items_enabled)

json.categories @categories do |category|
  json.call(category, :id, :name)
end

json.reservations @event.reservations do |reservation|
  json.call(reservation, :id, :number)
  json.seller reservation.seller, :id, :first_name, :last_name, :street, :zip_code, :city, :email, :phone
  json.items reservation.items do |item|
    json.call(item, :id, :category_id, :description, :size, :price, :number, :code, :sold, :donation)
  end
end
