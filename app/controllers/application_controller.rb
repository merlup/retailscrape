class ApplicationController < ActionController::Base
include SessionsHelper
include Authenticable
before_action -> { flash.now[:info] = flash[:info].html_safe if flash[:html_safe] && flash[:info] }
 protect_from_forgery with: :exception

 def logged_in_user
    unless logged_in? 
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
end
