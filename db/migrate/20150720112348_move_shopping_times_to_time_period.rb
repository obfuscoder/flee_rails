class MoveShoppingTimesToTimePeriod < ActiveRecord::Migration[4.2]
  class Event < ApplicationRecord
    has_one :shopping_period, -> { where kind: :shopping }, class_name: 'TimePeriod'
  end

  class TimePeriod < ApplicationRecord; end

  def up
    Event.find_each do |event|
      event.create_shopping_period! min: event.shopping_start, max: event.shopping_end
    end
  end

  def down
    Event.find_each do |event|
      event.update! shopping_start: event.shopping_period.min, shopping_end: event.shopping_period.max
    end
  end
end
