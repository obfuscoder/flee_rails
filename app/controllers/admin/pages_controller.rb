# frozen_string_literal: true

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
  end
end
