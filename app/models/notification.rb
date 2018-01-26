# frozen_string_literal: true

class Notification < ActiveRecord::Base
  belongs_to :event
  belongs_to :seller, -> { with_deleted }
  validates :seller, :event, presence: true
  validates :seller_id, uniqueness: { scope: :event_id }
end
