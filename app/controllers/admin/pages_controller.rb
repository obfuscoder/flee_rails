module Admin
  class PagesController < AdminController
    def home
      client = current_client
      @daily_sellers = daily_data_for(current_client.sellers)
      @daily_reservations = daily_data_for(Reservation.for_client(client))
      @daily_items = daily_data_for(Item.for_client(current_client))
    end

    def daily_data_for(clazz)
      daily_data(clazz.per_day(30))
    end

    def daily_data(items_hash)
      (29.days.ago.to_date..Time.zone.today).map { |day| day.strftime '%Y-%m-%d' }.map do |day|
        [day, items_hash[day] || 0]
      end
    end
  end
end
