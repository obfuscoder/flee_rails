class ReservedItem < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :item

  validates_presence_of :reservation, :item, :number, :code
  validates :number, numericality: { greater_than: 0 }

  def to_s
    code
  end
end
