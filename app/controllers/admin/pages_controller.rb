module Admin
  class PagesController < AdminController
    def home
    end

    def items_per_category
      categories = Category.joins { items }
                           .group { [id, name] }
                           .select { [name, count(items.id).as(count)] }
                           .order { count(items.id).desc }

      render json: categories.map { |category| [category.name, category.count] }.to_h
    end

    def items_per_day
      render json: daily_data_for(Item)
    end

    def daily_data_for(clazz)
      daily_data(created_objects_per_day clazz)
    end

    def daily_data(items_hash)
      days = (4.weeks.ago.to_date..Date.today).map { |date| date.strftime('%Y-%m-%d') }
      days.map { |day| [day, items_hash[day] || 0] }.to_h
    end

    def sellers_per_day
      render json: daily_data_for(Seller)
    end

    def created_objects_per_day(clazz)
      result = clazz.where { created_at.gteq 4.weeks.ago }
                    .group { date(created_at) }
                    .select { [date(created_at).as(date), count(id).as(count)] }
      result.map { |element| [element.date, element.count] }.to_h
    end
  end
end
