class User < ApplicationRecord
  has_secure_password
  has_many :features, dependent: :destroy

  normalizes :email, with: ->(email) { email.strip.downcase }

  validates :name, presence: true, length: { maximum: 100 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, if: -> { password.present? }

  def password_reset_token
    signed_id(expires_in: 30.minutes, purpose: "password_reset")
  end

  def self.find_by_password_reset_token(token)
    find_signed(token, purpose: "password_reset")
  end

  def self.find_by_password_reset_token!(token)
    find_signed!(token, purpose: "password_reset")
  end
end
