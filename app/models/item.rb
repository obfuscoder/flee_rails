class Item < ActiveRecord::Base
  belongs_to :seller
  belongs_to :category
  has_many :reserved_items, dependent: :destroy

  validates_presence_of :seller, :category, :description, :price

  scope :without_label, -> { joins{reserved_items.outer}.where{reserved_items.id == nil} }

  def to_s
    description || super
  end
end
