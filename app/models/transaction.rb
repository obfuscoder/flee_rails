# frozen_string_literal: true

class Transaction < ActiveRecord::Base
  enum kind: %i[sale refund]

  belongs_to :event

  validates :event, presence: true
  validates :kind, presence: true
  validates :number, presence: true, uniqueness: { scope: :event_id }
end
