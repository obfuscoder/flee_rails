module Admin
  class ItemsController < AdminController
    before_action do
      # TODO: RAILS 5.0 - check if params can still be read
      # see https://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#actioncontroller-parameters-no-longer-inherits-from-hashwithindifferentaccess
      @reservation = current_client.reservations.find params[:reservation_id]
    end
    before_action :init_categories, only: %i[edit new update create]
    before_action :set_item, only: %i[show edit update destroy delete_code]

    def index
      @items = @reservation.items
    end

    def show; end

    def new
      @item = @reservation.items.build donation: current_client.donation_of_unsold_items_default
    end

    def create
      @item = @reservation.items.build item_params

      if @item.save
        redirect_to admin_reservation_items_path(@reservation), notice: t('.success')
      else
        render :new
      end
    end

    def edit
      # TODO: RAILS 5.0 - check if params can still be read
      # see https://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#actioncontroller-parameters-no-longer-inherits-from-hashwithindifferentaccess
      @item = @reservation.items.find params[:id]
    end

    def update
      # TODO: RAILS 5.0 - check if params can still be read
      # see https://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#actioncontroller-parameters-no-longer-inherits-from-hashwithindifferentaccess
      @item = @reservation.items.find params[:id]
      if @item.update item_params
        redirect_to admin_reservation_items_path(@reservation), notice: t('.success')
      else
        render :edit
      end
    end

    def destroy
      if @item.destroy
        redirect_to admin_reservation_items_path(@reservation), notice: t('.success')
      else
        redirect_to admin_reservation_items_path(@reservation), alert: t('.failure')
      end
    end

    def delete_code
      @item.delete_code
      redirect_to admin_reservation_items_path(@reservation), notice: t('.success')
    end

    def delete_all_codes
      @reservation.items.each(&:delete_code)
      redirect_to admin_reservation_items_path(@reservation), notice: t('.success')
    end

    def labels
      @items = @reservation.items
    end

    def create_labels
      # TODO: RAILS 5.0 - check if params can still be read
      # see https://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#actioncontroller-parameters-no-longer-inherits-from-hashwithindifferentaccess
      selected_items = @reservation.items.where(id: params[:labels][:item])
      pdf = CreateLabelDocument.new(current_client, selected_items).call
      send_data pdf, filename: 'etiketten.pdf', type: 'application/pdf'
    end

    def item_params
      enforce_donation params.require(:item).permit(:category_id, :description, :size, :price, :donation, :gender)
    end

    def enforce_donation(parameters)
      return parameters unless @reservation.event.donation_of_unsold_items_enabled && parameters['category_id'].present?

      category = current_client.categories.find parameters['category_id']
      parameters['donation'] = true if category.donation_enforced
      parameters
    end

    private

    def set_item
      @item = @reservation.items.find params[:id]
    end

    def init_categories
      @categories = current_client.categories.merge(Category.selectable).order(:name).map do |category|
        element = [
          category.name,
          category.id
        ]
        data = { size_option: category.size_option }
        data[:sizes] = category.sizes.map(&:value).join('|')
        data[:gender] = category.gender?
        data[:donation_enforced] = category.donation_enforced? if @reservation.event.donation_of_unsold_items_enabled
        element << { data: data } unless data.empty?
        element
      end
    end
  end
end
