# frozen_string_literal: true

class Hardware < ActiveRecord::Base
  self.table_name = 'hardware'

  has_many :rentals
  validates :description, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }

  def to_s
    description
  end
end
