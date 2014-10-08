class Reservation < ActiveRecord::Base
  belongs_to :seller
  belongs_to :event
  has_many :reserved_item, dependent: :destroy

  validates_presence_of :seller, :event, :number
  validates :number, numericality: { greater_than: 0 }

  def to_s
    "#{event.name} - #{number}"
  end
end
