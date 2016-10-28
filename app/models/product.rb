class Product < ApplicationRecord
	belongs_to :user, optional: true
	
end
