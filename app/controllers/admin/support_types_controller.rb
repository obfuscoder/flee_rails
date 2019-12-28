module Admin
  class SupportTypesController < AdminController
    before_action :init_event

    def index
      @support_types = @event.support_types
    end

    def new
      @support_type = @event.support_types.build
    end

    def create
      @support_type = @event.support_types.build support_type_params
      if @support_type.save
        redirect_to admin_event_support_types_path(@event), notice: t('.success')
      else
        render :new
      end
    end

    def edit
      @support_type = @event.support_types.find params[:id]
    end

    def update
      @support_type = @event.support_types.find params[:id]
      if @support_type.update support_type_params
        redirect_to admin_event_support_types_path(@event), notice: t('.success')
      else
        render :edit
      end
    end

    def destroy
      support_type = @event.support_types.find params[:id]
      support_type.destroy
      redirect_to admin_event_support_types_path(@event), notice: t('.success')
    end

    def print
      pdf = SupportTypesDocument.new(@event, @event.support_types).render
      send_data pdf, filename: 'helfer.pdf', type: 'application/pdf'
    end

    private

    def init_event
      @event = current_client.events.find params[:event_id]
    end

    def support_type_params
      params.require(:support_type).permit :name, :description, :capacity
    end
  end
end
