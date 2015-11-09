module Admin
  class CategoriesController < AdminController
    def index
      @categories = Category.page(@page).order(column_order)
    end

    def new
      @category = Category.new
    end

    def create
      @category = Category.new category_params
      if @category.save
        redirect_to admin_categories_path, notice: t('.success')
      else
        render :new
      end
    end

    def edit
      @category = Category.find params[:id]
    end

    def update
      @category = Category.find params[:id]
      if @category.update(category_params)
        redirect_to admin_categories_path, notice: t('.success')
      else
        render :edit
      end
    end

    def show
      @category = Category.find params[:id]
    end

    def destroy
      if Category.destroy params[:id]
        redirect_to admin_categories_path, notice: t('.success')
      else
        redirect_to admin_categories_path, alert: t('.failure')
      end
    end

    private

    def category_params
      params.require(:category).permit :name, :donation_enforced, :max_items_per_seller
    end
  end
end
