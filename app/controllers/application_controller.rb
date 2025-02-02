class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  include Authenticatable

  private

  def set_current_user
    Current.user ||= User.find_by(session_token: session[:session_token])
  end
end
