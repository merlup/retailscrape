module Api
	class UsersController  < JSONAPI::ResourceController
	
	def show
		@user = User.find_by_id(params[:id]) || @user = User.find_by_user_name(params[:user_name])
		render json: @user.products.to_json
	end

	def create
		@user = User.create(user_params)
		@user.save 
		p "fuck"
	end
	

	private 
		def user_params
			params.require(:user).permit(:user_name, :password, :products, collection_attributes: [:id, :line_items ])
		end
	end

end