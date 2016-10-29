class SessionsController < ApplicationController

	def new
  end

	def create
		user = User.find_by(user_name: params[:session][:user_name])
		if user.blank?
			flash[:danger] = "User Does Not Exsist"
			render 'new'
		end

		if user && user.authenticate(params[:session][:password]) 
			log_in user
			redirect_to root_url
		else
			flash[:danger] = 'Invalid email/password combination'
	       render 'new'
    	end
 	end

 	def destroy
    	log_out if logged_in?
    	render :nothing => true
  	end
end
