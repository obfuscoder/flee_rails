class GeneratePassword
  def self.execute
    loop do
      pwd = SecureRandom.urlsafe_base64(8, false)
      return pwd if strong?(pwd)
    end
  end

  def self.strong?(password)
    password.present? &&
      password.size >= 5 &&
      password.match(/[[:digit:]]/) &&
      password.match(/[[:lower:]]/) &&
      password.match(/[[:upper:]]/)
  end
end
