class ApiKeysController < ApplicationController

def new
	if current_user != nil
		@api_key = ApiKey.create
	end
end

def create
	@api_key = ApiKey.create(params[:api_key_params])
	@api_key.user_id = current_user.id
	redirect_to root_url
end

def update
	@api_key = ApiKey.find_by_id(params[:id])
	@api_key.user_id = current_user.id
	@api_key.save
	redirect_to root_url
end

private
	def api_key_params
		permit.require(:api_key).permit(:access_token, :user_id)
	end
end