class User < ActiveRecord::Base
  authenticates_with_sorcery!

  attr_accessor :old_password
  attr_accessor :password_confirmation

  validates_confirmation_of :password, on: :update
  validates_presence_of :old_password, :password, :password_confirmation, on: :update
  validate :old_password_correct, on: :update
  validate :password_differs_from_old_password, on: :update

  private

  def old_password_correct
    errors.add(:old_password, :incorrect) if User.authenticate(email, old_password).nil?
  end

  def password_differs_from_old_password
    errors.add(:password, :no_change) if password == old_password
  end
end
