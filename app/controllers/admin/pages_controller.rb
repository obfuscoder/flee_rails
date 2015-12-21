module Admin
  class PagesController < AdminController
    def home
    end

    def items_per_category
      categories = Category.joins { items }
                           .group { [id, name] }
                           .select { [name, count(items.id).as(count)] }
                           .order { count(items.id).desc }

      render json: categories.map { |category| [category.name, category.count] }
    end

    def items_per_day
      render json: daily_data_for(Item)
    end

    def daily_data_for(clazz)
      daily_data(clazz.per_day 30)
    end

    def daily_data(items_hash)
      (29.days.ago.to_date..Date.today).map { |day| day.strftime '%Y-%m-%d' }.map do |day|
        [day, items_hash[day] || 0]
      end
    end

    def sellers_per_day
      render json: daily_data_for(Seller)
    end
  end
end
