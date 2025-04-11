class Invitation < ApplicationRecord
  before_create :generate_token

  validates :email, presence: true
  validates :token, uniqueness: true

  def generate_token
    self.token = SecureRandom.hex(10) # = 20 chars
  end

  def expired?
    Time.current > expires_at
  end
end
