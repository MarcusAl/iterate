module Authenticatable
  extend ActiveSupport::Concern

  included do
    before_action :set_current_user
    helper_method :current_user
  end

  private

  def current_user
    return @current_user if defined?(@current_user)

    token = cookies.signed[:session_token]
    @current_user = token ? User.find_by(session_token: token) : nil
  end

  def ensure_user
    user = User.create!
    cookies.signed[:session_token] = {
      value: user.session_token,
      expires: 1.year.from_now,
      httponly: true,
      secure: !Rails.env.development?
    }
    @current_user = user
  end

  def set_current_user
    ensure_user unless @current_user.present?

    Current.user = @current_user
  end
end
