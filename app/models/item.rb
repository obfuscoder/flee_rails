class Item < ActiveRecord::Base
  belongs_to :seller
  belongs_to :category
  has_many :labels, dependent: :destroy

  validates_presence_of :seller, :category, :description, :price

  scope :without_label, -> { joins { labels.outer } .where { labels.id.eq nil } }
  scope :with_reservation, -> { joins { seller.reservations } }

  def to_s
    description || super
  end
end
