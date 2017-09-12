# frozen_string_literal: true

class Rental < ActiveRecord::Base
  belongs_to :event
  belongs_to :hardware

  validates :amount, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :hardware, presence: true, uniqueness: { scope: :event_id }
  validates :event, presence: true
end
