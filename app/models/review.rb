class Review < ApplicationRecord
  belongs_to :reservation

  validates :reservation, presence: true
  validates :reservation_id, uniqueness: true
end
