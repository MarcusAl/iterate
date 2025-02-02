# == Schema Information
#
# Table name: users
#
#  id            :uuid             not null, primary key
#  admin         :boolean          default(FALSE), not null
#  session_token :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_users_on_session_token  (session_token) UNIQUE
#
class User < ApplicationRecord
  before_validation :ensure_session_token

  private

  def ensure_session_token
    self.session_token ||= generate_unique_session_token
  end

  def generate_unique_session_token
    loop do
      token = SecureRandom.urlsafe_base64
      return token unless User.exists?(session_token: token)
    end
  end
end
