module Admin
  class PagesController < AdminController
    def home
    end

    def items_per_category
      @categories = Category.joins{items}.group{[id,name]}.select{
        [name,count(items.id).as(count)]}.order{count(items.id).desc}

      render json: @categories.map { |category| [ category.name, category.count ] }.to_h
    end
  end
end
