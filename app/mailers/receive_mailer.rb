# frozen_string_literal: true

class ReceiveMailer < ActionMailer::Base
  def receive(message)
    CreateEmail.new(message).call(false)
  end
end
