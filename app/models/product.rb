class Product < ApplicationRecord
	belongs_to :user, optional: true
	attr_accessor :remote_image_url
	mount_uploader :image, ProductImageUploader
	 
end
