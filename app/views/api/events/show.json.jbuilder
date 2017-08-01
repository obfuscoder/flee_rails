# frozen_string_literal: true

json.call @event, :id, :name, :price_precision, :commission_rate, :seller_fee,
          :donation_of_unsold_items_enabled, :reservation_fees_payed_in_advance

json.categories @categories, :id, :name

json.stock_items @stock_items, :id, :description, :price, :number, :code

json.sellers @event.reservations.map(&:seller), :id, :first_name, :last_name, :street, :zip_code, :city, :email, :phone

json.reservations @event.reservations, :id, :number, :seller_id, :fee, :commission_rate

json.items @event.reservations.map(&:items).flatten, :id, :category_id, :reservation_id,
           :description, :size, :price, :number, :code, :sold, :donation
