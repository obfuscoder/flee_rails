# frozen_string_literal: true

class Transaction < ApplicationRecord
  enum kind: { purchase: 0, refund: 1 }

  belongs_to :event
  has_many :items, through: :transaction_items
  has_many :transaction_items, dependent: :delete_all
  has_many :stock_items, through: :transaction_stock_items
  has_many :transaction_stock_items, dependent: :delete_all

  validates :event, presence: true
  validates :kind, presence: true
  validates :number, presence: true, uniqueness: { scope: :event_id }
end
