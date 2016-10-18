class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  Tmdb::Api.key('f4702b08c0ac6ea5b51425788bb26562')
  protect_from_forgery with: :exception
end
