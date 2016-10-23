module Api
	class UserResource < JSONAPI::Resource
		attributes :user_name, :collections, :products
	end
end