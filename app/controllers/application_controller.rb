class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  if Rails.env.qa? || Rails.env.staging?
    http_basic_authenticate_with name: "greatminds", password: "intridea4gm"
  end
end
