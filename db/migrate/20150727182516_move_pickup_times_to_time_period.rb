# frozen_string_literal: true

class MovePickupTimesToTimePeriod < ActiveRecord::Migration
  class Event < ApplicationRecord
    has_many :pickup_periods, -> { where kind: :pickup }, class_name: 'TimePeriod'
  end
  class TimePeriod < ApplicationRecord; end

  def up
    Event.find_each do |event|
      event.pickup_periods.create! min: event.pickup_start, max: event.pickup_end
    end
  end

  def down
    Event.find_each do |event|
      event.update! pickup_start: event.pickup_periods.first.min, pickup_end: event.pickup_periods.last.max
      event.pickup_periods.destroy_all
    end
  end
end
