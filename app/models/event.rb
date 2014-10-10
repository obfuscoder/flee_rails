class Event < ActiveRecord::Base
  has_many :reservation, dependent: :destroy

  validates_presence_of :name
  validates :max_sellers, numericality: { greater_than: 0, only_integer: true }

  def to_s
    name || super
  end
end
