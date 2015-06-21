module Admin
  class ReviewsController < AdminController
    def index
      @event = Event.find params[:event_id]
      @reviews = @event.reviews
    end
  end
end
