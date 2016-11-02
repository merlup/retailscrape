class UsersController < ApplicationController

		# Needs Cleanup and Refactoring

	def create
		@user = User.new(user_params)
		if @user.save
			flash[:success] = "Welcome to the App"
			current_user = @user
			 session[:user_id] = @user.id

			log_in @user
			redirect_to products_path
			else 
			flash[:warning] = @user.errors.full_messages.to_sentence
			render new_user_path
		end
	end

	def show 
		if logged_in? && current_user.id == params[:id]
		@user = User.find_by_id(params[:id])
		else
			flash[:notice] = "Please Log In or Create an Account"
			redirect_to root_url
		end
	end

	def index 
		@user = User.find_by_id(current_user.id)
		if correct_user?
			@users = User.all
		else
			redirect_to root_url
			flash[:warning] = "You prolly shouldn't be doing that"
		end
	end

	def new
		@user = User.new
	end

	def destroy
		if correct_user?
			@user = User.find_by_id(params[:id])
			@user.destroy
			flash[:sucess] = "User has been destroyed"
			redirect_to users_url
		else
			redirect_to back
			flash[:warning] = "Not for you to touch"
		end
	end

	def update
	if correct_user_profile?
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      if @user.activated?
        flash[:success] = "Updated"
        redirect_to back
      else 
       redirect_to back
       flash[:notice] = "Try that Again" 
      end
    else
      render back
    end
	else
		redirect_to root_url
	end
  end


private

	def correct_user_profile?
		current_user.id == @user.id
	end

	def correct_user?
		current_user.user_name == "smart_dev"
	end

	def user_params
		params.require(:user).permit(:api_key, :user_name, :password, :products, :auth_token, collection_attributes: [:id, :line_items ])
	end

end
