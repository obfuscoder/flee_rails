# frozen_string_literal: true

class Message < ActiveRecord::Base
  belongs_to :event
end
