# frozen_string_literal: true

class MailObserver
  def self.delivered_email(message)
    CreateEmail.new(message).call(true)
  end
end
