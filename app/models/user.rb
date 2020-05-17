class User < ApplicationRecord
  has_secure_password

  validates :username, presence: true, uniqueness: true

  after_initialize do |user|
    user.password = SecureRandom.base64(32) unless user.password_digest
  end

  def initialize_dup(*)
    self.username = nil
    self.password = SecureRandom.base64(32)
    super
  end

  def username=(other)
    super(other&.downcase)
  end
end
