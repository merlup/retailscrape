module Api
  class SessionsController < ApplicationController

    def create
      p "here"
      user_password = params[:session][:password]

     
      user_name = params[:session][:user_name]
       p user_name
      user = user_name.present? && User.find_by(user_name: user_name)
      if user_password
        log_in user
        render json: user, status: 200, location: [:api, user]
      else
        render json: { errors: "Invalid email or password" }, status: 422
      end
    end

    def new
    end

    def destroy
      user = User.find_by(auth_token: params[:id])
      user.generate_authentication_token!
      user.save
      head 204
    end
     def user_signed_in?
      current_user.present?
    end

 
  end
end
