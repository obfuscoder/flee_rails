# frozen_string_literal: true

class SupportType < ActiveRecord::Base
  belongs_to :event
  has_many :supporters, dependent: :delete_all
  validates :name, presence: true
  validates :capacity, presence: true, numericality: { greater_than: 0, only_integer: true }
end