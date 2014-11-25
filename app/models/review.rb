class Review < ActiveRecord::Base
  belongs_to :event
  belongs_to :seller

  validates_presence_of :seller, :event
  validates :seller_id, uniqueness: {scope: :event_id}
end
