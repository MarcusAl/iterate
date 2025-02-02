class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  include Authenticatable
  include Pagy::Backend
end
