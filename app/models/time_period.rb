class TimePeriod < ApplicationRecord
  belongs_to :event

  validate :min_before_max

  private

  def min_before_max
    errors.add :max, :before_min if max < min
  end
end
