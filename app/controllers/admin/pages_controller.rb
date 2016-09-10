module Admin
  class PagesController < AdminController
    def home
      @daily_sellers = daily_data_for(Seller)
      @daily_items = daily_data_for(Item)
      @daily_reservations = daily_data_for(Reservation)
    end

    def daily_data_for(clazz)
      daily_data(clazz.per_day(30))
    end

    def daily_data(items_hash)
      (29.days.ago.to_date..Date.today).map { |day| day.strftime '%Y-%m-%d' }.map do |day|
        [day, items_hash[day] || 0]
      end
    end

    def restore
      return unless request.post?
      backup = JSON.parse params[:backup].read
      date = 1.month.from_now.at_midday
      event = Event.new id: backup['id'],
                        max_sellers: 500,
                        name: backup['name'],
                        token: backup['token'],
                        price_precision: backup['price_precision'],
                        commission_rate: backup['commission_rate'],
                        seller_fee: backup['seller_fee'],
                        donation_of_unsold_items_enabled: backup['donation_of_unsold_items_enabled'],
                        reservation_start: date - 2.weeks, reservation_end: date - 2.days,
                        shopping_periods_attributes: [min: date, max: date + 2.hours],
                        handover_periods_attributes: [min: date - 1.day, max: date - 1.day + 2.hours],
                        pickup_periods_attributes: [min: date + 4.hours, max: date + 6.hours]
      event.save validate: false

      backup['categories'].each { |category| Category.create! id: category['id'], name: category['name'] }

      backup['sellers'].each do |seller|
        s = Seller.new id: seller['id'],
                       first_name: seller['first_name'],
                       last_name: seller['last_name'],
                       street: seller['street'],
                       zip_code: seller['zip_code'],
                       city: seller['city'],
                       email: seller['email'],
                       phone: seller['phone']
        s.save validate: false
      end

      backup['reservations'].each do |reservation|
        r = Reservation.new id: reservation['id'],
                            number: reservation['number'],
                            seller_id: reservation['seller_id'],
                            event: event
        r.save validate: false
      end

      backup['items'].each do |item|
        i = Item.new id: item['id'],
                     category_id: item['category_id'],
                     description: item['description'],
                     size: item['size'],
                     price: item['price'],
                     reservation_id: item['reservation_id'],
                     number: (item['number'] > 0 ? item['number']:nil),
                     code: item['code'],
                     donation: item['donation']
        i.save validate: false
      end
    end
  end
end
