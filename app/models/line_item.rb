class LineItem < ApplicationRecord
	mount_uploader :image , LineItemUploader
  belongs_to :collection, optional: true
end
