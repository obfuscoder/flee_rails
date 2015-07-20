class MoveShoppingTimesToTimePeriod < ActiveRecord::Migration
  def up
    Event.find_each do |event|
      event.create_shopping_period! from: event.shopping_start, to: event.shopping_end
    end
  end

  def down
    Event.find_each do |event|
      event.update! shopping_start: event.shopping_period.from, shopping_end: event.shopping_period.to
    end
  end
end
