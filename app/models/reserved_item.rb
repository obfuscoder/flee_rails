class ReservedItem < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :item

  validates_presence_of :reservation, :item, :number, :code
end
