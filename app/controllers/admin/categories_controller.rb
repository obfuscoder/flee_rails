module Admin
  class CategoriesController < AdminController
    before_filter :set_category, only: [:edit, :update, :show]

    def index
      @categories = Category.page(@page).order column_order
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

    def edit; end

    def update
      if @category.update category_params
        redirect_to admin_categories_path, notice: t('.success')
      else
        render :edit
      end
    end

    def show; end

    def destroy
      if Category.destroy params[:id]
        redirect_to admin_categories_path, notice: t('.success')
      else
        redirect_to admin_categories_path, alert: t('.failure')
      end
    end

    private

    def category_params
      params.require(:category).permit :name, :donation_enforced, :max_items_per_seller, :parent_id
    end

    def set_category
      @category = Category.find params[:id]
    end
  end
end
