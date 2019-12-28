class ReceiveMailer < ApplicationMailer
  def receive(message)
    CreateEmail.new(message).call(false)
  end
end
