class User < ApplicationRecord
  has_secure_password

  has_many :todos, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :auth_token, presence: true, uniqueness: true

  before_validation :ensure_auth_token

  def rotate_token!
    update!(auth_token: self.class.generate_unique_token)
  end

  def self.generate_unique_token
    loop do
      token = SecureRandom.hex(24)
      return token unless exists?(auth_token: token)
    end
  end

  private

  def ensure_auth_token
    self.auth_token ||= self.class.generate_unique_token
  end
end
