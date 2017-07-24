# frozen_string_literal: true

module Statistics
  extend ActiveSupport::Concern

  module ClassMethods
    def per_day(day_count = 30)
      result = where { created_at.gteq day_count.days.ago }.group('substr(created_at,1,10)').select do
        [substr(created_at, 1, 10).as(date), count(id).as(count)]
      end
      result.map { |element| [element.date, element.count] }.to_h
    end
  end
end
