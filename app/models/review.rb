# frozen_string_literal: true

class Review < ActiveRecord::Base
  belongs_to :reservation

  validates_presence_of :reservation

  validates :reservation_id, uniqueness: true
end
