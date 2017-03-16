class Review < ActiveRecord::Base
  belongs_to :reservation

  validates_presence_of :reservation

  validates :reservation_id, uniqueness: true
end
