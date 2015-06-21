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
      items_hash = items_per_day_as_hash
      days = (4.weeks.ago.to_date..Date.today).map { |date| date.strftime('%Y-%m-%d') }
      data = days.map { |day| [day, items_hash[day] || 0] }.to_h
      render json: data
    end

    def items_per_day_as_hash
      items = Item.where { created_at.gt 1.month.ago }
                  .group { date(created_at) }
                  .select { [date(created_at).as(date), count(id).as(count)] }
      items.map { |item| [item.date, item.count] }.to_h
    end
  end
end
