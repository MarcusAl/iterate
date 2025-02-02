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
require 'securerandom'

FactoryBot.define do
  factory :user do
    session_token { SecureRandom.urlsafe_base64 }
    admin { false }
  end

  trait :admin do
    admin { true }
  end
end
