class Event < ActiveRecord::Base
  has_many :reservation, dependent: :destroy

  validates_presence_of :name
  validates :max_sellers, numericality: { greater_than: 0 }

  def to_s
    name
  end
end
