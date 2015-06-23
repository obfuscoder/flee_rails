class User < ActiveRecord::Base
  authenticates_with_sorcery!

  attr_accessor :old_password
  attr_accessor :password_confirmation

  validates_confirmation_of :password, on: :update
  validates_presence_of :old_password, :password, :password_confirmation, on: :update
  validate :old_password_correct, on: :update

  private

  def old_password_correct
    return if User.authenticate(email, old_password).present?
    errors.add(:old_password, :incorrect)
  end
end
