# frozen_string_literal: true

module Statistics
  extend ActiveSupport::Concern

  module ClassMethods
    def per_day(day_count = 30)
      result = where.has { created_at.gteq day_count.days.ago }.grouping { substr(created_at, 1, 10) }.selecting do
        [substr(created_at, 1, 10).as('date'), id.count.as('count')]
      end
      result.map { |element| [element.date, element.count] }.to_h
    end
  end
end
