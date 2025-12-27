class CreateEmail
  def initialize(message)
    @message = message
  end

  def call
    orga_mail = Mail::Address.new(@message.from.first)
    client = find_client(orga_mail)
    return unless client

    seller_mail = @message.to.first
    seller = client.sellers.where(email: seller_mail).first
    return unless seller

    Email.create! kind: :custom, seller: seller, message_id: @message.message_id,
                  subject: @message.subject, to: @message.to.first, from: @message.from.first, body: body(@message)
  end

  private

  def find_client(mail_address)
    Client.find_by(mail_address: mail_address.address) || Client.find_by(key: mail_address.local)
  end

  def body(message)
    strip_four_byte_chars(find_text(message).decoded)
  end

  def strip_four_byte_chars(text)
    return nil if text.nil?

    text.each_char.select { |c| c.bytes.count < 4 }.join('')
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
