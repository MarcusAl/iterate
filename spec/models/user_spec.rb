# frozen_string_literal: true

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

RSpec.describe User do
  describe 'session token generation' do
    subject(:user) { build(:user, session_token: nil) }

    context 'when validating a new user' do
      it 'assigns a session token' do
        expect { user.valid? }.to change(user, :session_token).from(nil).to(be_present)
      end
    end

    context 'when session token already exists' do
      before { user.valid? }

      it 'preserves the existing token' do
        original_token = user.session_token
        expect { user.valid? }.not_to change(user, :session_token).from(original_token)
      end
    end

    context 'when generating multiple tokens' do
      it 'ensures uniqueness' do
        tokens = Array.new(5) do
          create(:user).session_token
        end

        expect(tokens.uniq.count).to eq(5)
      end
    end
  end

  describe 'defaults' do
    subject(:user) { build(:user) }

    it 'sets admin flag to false' do
      expect(user).not_to be_admin
    end
  end
end
