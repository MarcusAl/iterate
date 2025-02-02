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
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'session token' do
    it 'assigns a session token before validation' do
      user = build(:user)
      user.valid?
      expect(user.session_token).to be_present
    end

    it 'does not change the session token if one already exists' do
      user = build(:user)
      user.valid?
      original_token = user.session_token
      user.valid?
      expect(user.session_token).to eq(original_token)
    end

    it 'generates unique session tokens' do
      tokens = Array.new(5) do
        user = build(:user)
        user.valid?
        user.session_token
      end
      expect(tokens.uniq).to eq(tokens)
    end
  end

  describe 'validations' do
    it 'builds a user with a session token if not provided' do
      user = build(:user)
      user.session_token = nil
      user.valid?
      expect(user.session_token).to be_present
    end
  end

  describe 'admin flag' do
    it 'defaults to false' do
      user = build(:user)
      expect(user.admin).to be false
    end
  end
end
