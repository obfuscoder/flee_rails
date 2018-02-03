# frozen_string_literal: true

class MoveHandoverTimesToTimePeriod < ActiveRecord::Migration
  class Event < ActiveRecord::Base
    has_many :handover_periods, -> { where kind: :handover }, class_name: 'TimePeriod'
  end
  class TimePeriod < ActiveRecord::Base; end

  def up
    Event.find_each do |event|
      event.handover_periods.create! min: event.handover_start, max: event.handover_end
    end
  end

  def down
    Event.find_each do |event|
      event.update! handover_start: event.handover_periods.first.min, handover_end: event.handover_periods.last.max
      event.handover_periods.destroy_all
    end
  end
end
