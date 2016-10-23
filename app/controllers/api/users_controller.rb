module Api
	class UsersController  < JSONAPI::ResourceController
	
  
	def show
		@user = User.find_by(params[:user_name]) || @user = User.find_by_user_name(params[:user_name])
		render json: @user.products.to_json
	end

	def update
    user = current_user

    if user.update(user_params)
      render json: user, status: 200, location: [:api, user]
    else
      render json: { errors: user.errors }, status: 422
    end
  end
	

	private 
		def user_params
			params.require(:user).permit(:user_name, :password, :products, collection_attributes: [:id, :line_items ])
		end
	end

end