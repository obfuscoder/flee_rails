class Notification < ApplicationRecord
  belongs_to :event
  belongs_to :seller, -> { with_deleted }, inverse_of: :notifications

  validates :seller, :event, presence: true
  validates :seller_id, uniqueness: { scope: :event_id }
end
