json.call @event, :id, :name, :price_precision, :commission_rate, :seller_fee, :donation_of_unsold_items_enabled

json.categories @categories, :id, :name

json.sellers @event.reservations.map(&:seller), :id, :first_name, :last_name, :street, :zip_code, :city, :email, :phone

json.reservations @event.reservations, :id, :number, :seller_id

json.items @event.reservations.map(&:items).flatten, :id, :category_id, :reservation_id,
           :description, :size, :price, :number, :code, :sold, :donation
