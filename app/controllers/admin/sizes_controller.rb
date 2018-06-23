# frozen_string_literal: true

module Admin
  class SizesController < AdminController
    before_action :set_category
    before_action :set_size, only: %i[show edit update destroy]

    def index
      @sizes = @category.sizes.page(@page).order column_order
    end

    def new
      @size = @category.sizes.build
    end

    def create
      @size = @category.sizes.build size_params
      if @size.save
        redirect_to admin_category_sizes_path(@category), notice: t('.success')
      else
        render :new
      end
    end

    def edit; end

    def update
      if @size.update size_params
        redirect_to admin_category_sizes_path(@category), notice: t('.success')
      else
        render :edit
      end
    end

    def destroy
      if @size.destroy
        redirect_to admin_category_sizes_path(@category), notice: t('.success')
      else
        redirect_to admin_category_sizes_path(@category), alert: t('.failure')
      end
    end

    private

    def size_params
      params.require(:size).permit :value
    end

    def set_category
      @category = current_client.categories.find params[:category_id]
    end

    def set_size
      @size = @category.sizes.find params[:id]
    end
  end
end
