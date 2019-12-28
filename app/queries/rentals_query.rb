class RentalsQuery
  def initialize(event)
    @event = event
  end

  def rentable_hardware
    Hardware.where.not(id: all.map(&:hardware_id))
  end

  def new
    all.build
  end

  delegate :create, :find, to: :all

  def update(id, params)
    rental = find(id)
    rental.update(params)
    rental
  end

  def all
    @event.rentals.joins(:hardware).includes(:hardware).order('hardware.description')
  end
end
