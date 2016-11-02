class SessionsController < ApplicationController

	def new
  end

	def create
		user = User.find_by(user_name: params[:session][:user_name])
		if user.blank?
			
			render 'new'
		end

		if user && user.authenticate(params[:session][:password]) 
			log_in user
			redirect_to products_path
		else
			
	       render 'new'
    	end
 	end

 	def destroy
    	log_out if logged_in?
    	redirect_to root_url
  	end
end
