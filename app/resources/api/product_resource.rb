module Api
	class ProductResource < JSONAPI::Resource
		attributes :price , :brand, :description, :sale, :sale_price, :image, :image_url
	end
end