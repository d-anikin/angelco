class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def authenticate_admin_user!
    authenticate_or_request_with_http_basic do |username, password|
      username == 'admin' && password == (ENV['ADMIN_PASSWORD'] || 'admin')
    end
  end
end
