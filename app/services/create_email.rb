# frozen_string_literal: true

class CreateEmail
  def initialize(message)
    @message = message
  end

  def call(sent)
    seller_mail = sent ? @message.to.first : @message.from.first
    seller = Seller.find_by email: seller_mail
    Email.create! kind: :custom, seller: seller, sent: sent, message_id: @message.message_id,
                  subject: @message.subject, to: @message.to.first, from: @message.from.first, body: body(@message)
  end

  private

  def body(message)
    find_text(message).decoded
  end

  def find_text(message)
    return message if message.text?
    find_text_part(message.parts) if message.multipart?
  end

  def find_text_part(parts)
    parts.each do |part|
      text = find_text part
      return text unless text.nil?
    end
  end
end
