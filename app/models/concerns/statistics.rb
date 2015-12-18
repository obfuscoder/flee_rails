module Statistics
  extend ActiveSupport::Concern

  module ClassMethods
    def per_day(day_count=30)
      result = where { created_at.gteq day_count.days.ago }.group('date(created_at)').select { [date(created_at).as(date), count(id).as(count)] }
      result.map { |element| [element.date, element.count] }.to_h
    end
  end
end
