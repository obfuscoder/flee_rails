class SupportType < ApplicationRecord
  belongs_to :event
  has_many :supporters, dependent: :delete_all

  validates :name, presence: true
  validates :capacity, presence: true, numericality: { greater_than: 0, only_integer: true }
end
