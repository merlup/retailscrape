class LineItem < ApplicationRecord
	attr_accessor :image_url
	mount_uploader :image , LineItemUploader
  belongs_to :collection, optional: true
end
