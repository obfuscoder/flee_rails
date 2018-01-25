# frozen_string_literal: true

class Notification < ActiveRecord::Base
  belongs_to :event
  belongs_to :seller, -> { with_deleted }
  validates_presence_of :seller, :event
  validates :seller_id, uniqueness: { scope: :event_id }
end
