class Item < ActiveRecord::Base
  belongs_to :seller
  belongs_to :category
  has_many :reserved_item, dependent: :destroy

  validates_presence_of :seller, :category, :description, :price

  def to_s
    description
  end
end
