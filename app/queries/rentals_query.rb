# frozen_string_literal: true

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

  def create(params)
    all.create params
  end

  def update(id, params)
    rental = find(id)
    rental.update(params)
    rental
  end

  def find(id)
    all.find(id)
  end

  def all
    @event.rentals.joins(:hardware).includes(:hardware).order('hardware.description')
  end
end
