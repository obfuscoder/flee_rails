class ReservedItemsController < ApplicationController
  before_action :set_reserved_item, only: [:show, :edit, :update, :destroy]

  # GET /reserved_items
  # GET /reserved_items.json
  def index
    @reserved_items = ReservedItem.all
  end

  # GET /reserved_items/1
  # GET /reserved_items/1.json
  def show
  end

  # GET /reserved_items/new
  def new
    @reserved_item = ReservedItem.new
  end

  # GET /reserved_items/1/edit
  def edit
  end

  # POST /reserved_items
  # POST /reserved_items.json
  def create
    @reserved_item = ReservedItem.new(reserved_item_params)

    respond_to do |format|
      if @reserved_item.save
        format.html { redirect_to @reserved_item, notice: 'Reserved item was successfully created.' }
        format.json { render :show, status: :created, location: @reserved_item }
      else
        format.html { render :new }
        format.json { render json: @reserved_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reserved_items/1
  # PATCH/PUT /reserved_items/1.json
  def update
    respond_to do |format|
      if @reserved_item.update(reserved_item_params)
        format.html { redirect_to @reserved_item, notice: 'Reserved item was successfully updated.' }
        format.json { render :show, status: :ok, location: @reserved_item }
      else
        format.html { render :edit }
        format.json { render json: @reserved_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reserved_items/1
  # DELETE /reserved_items/1.json
  def destroy
    @reserved_item.destroy
    respond_to do |format|
      format.html { redirect_to reserved_items_url, notice: 'Reserved item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reserved_item
      @reserved_item = ReservedItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reserved_item_params
      params.require(:reserved_item).permit(:reservation_id, :item_id, :number, :code)
    end
end
