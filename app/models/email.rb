class Email < ActiveRecord::Base
  belongs_to :seller

  validates_presence_of :subject, :body, :seller, :to

  attr_accessor :sellers
  attr_accessor :active
  attr_accessor :reservation
  attr_accessor :reservation_event
  attr_accessor :notification
  attr_accessor :notification_event
  attr_accessor :with_items
end
