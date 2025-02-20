class ReceiveMail
  def self.call(data)
    CreateEmail.new(Mail.read_from_string(data)).call(false)
  end
end
