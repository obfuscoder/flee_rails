# frozen_string_literal: true

module Admin
  class CategoriesController < AdminController
    before_action :set_category, only: %i[destroy edit update show]

    def index
      @categories = current_client.categories.page(@page).order column_order
    end

    def new
      @category = current_client.categories.build
    end

    def create
      @category = current_client.categories.build category_params
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
      if @category.destroy
        redirect_to admin_categories_path, notice: t('.success')
      else
        redirect_to admin_categories_path, alert: t('.failure')
      end
    end

    private

    def category_params
      params.require(:category).permit :name,
                                       :donation_enforced,
                                       :max_items_per_seller,
                                       :parent_id,
                                       :size_option,
                                       :gender
    end

    def set_category
      @category = current_client.categories.find params[:id]
    end
  end
end
