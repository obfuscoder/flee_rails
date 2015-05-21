module Admin
  class EventsController < AdminController
    def index
      @objects = Event.all
    end
  end
end
