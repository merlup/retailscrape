module Api
	class ProductsController  < JSONAPI::ResourceController
	before_action :restrict_access, only: [:index]

	  def app_api
	  	render template: "products/app_api"
	  end


def get_type
	type = params[:type]

	# The below case method creates two variables. Model Type & Model ID which are later needed to query multiple pages on the scraped website. 
	# Doc is short for document which is Nokogiri uses to parse.
	case type
		when "jeans"
		@model_type = "jeans"
		@model_id = 10172
		@doc = Nokogiri::HTML(open("http://www1.bloomingdales.com/shop/mens/jeans?id=10172&cm_sp=categorysplash_men_men_1-_-row6_image_n-_-GEOR0_mens-jeans"))
		when "coats-jackets"
		@model_type = "coats-jackets"
		@model_id = 11548
		@doc = Nokogiri::HTML(open("http://www1.bloomingdales.com/shop/mens/coats-jackets?id=11548&cm_sp=categorysplash_men_men_1-_-row6_image_n-_-GEOR0_mens-coats-%2526-jackets"))
		when "button-downs"
		@model_type = "casual-button-down-shirts"
		@model_id = 17648
		@doc = Nokogiri::HTML(open("http://www1.bloomingdales.com/shop/mens/casual-button-down-shirts?id=17648&cm_sp=categorysplash_men_men_1-_-row7_image_n-_-GEOR0_mens-casual-button-downs"))
		when "suits-tux"
		@model_type = "suits-tuxedos"
		@model_id = 1003462
		@doc = Nokogiri::HTML(open("http://www1.bloomingdales.com/shop/mens/suits-tuxedos?id=1003462&cm_sp=categorysplash_men_men_1-_-row7_image_n-_-GEOR0_mens-suits-%2526-tuxedos"))
		when "belts"
		@model_type = "belts"
		@model_id = 1000060
		@doc = Nokogiri::HTML(open("http://www1.bloomingdales.com/shop/mens/belts?id=1000060&cm_sp=categorysplash_men_men_1-_-row6_image_n-_-GEOR0_mens-belts"))
		when "dress-shoes"
		@model_type = "dress-shoes"
		@model_id = 1001183
		@doc = Nokogiri::HTML(open("http://www1.bloomingdales.com/shop/mens/dress-shoes?id=1001183&cm_sp=categorysplash_men_men_1-_-row7_image_n-_-GEOR0_mens-dress-shoes"))
		when "sneakers"
		@model_type = "sneakers-athletic"
		@model_id = 1000054
		@doc = Nokogiri::HTML(open("http://www1.bloomingdales.com/shop/mens/sneakers-athletic?id=1000054&cm_sp=categorysplash_men_men_1-_-row6_image_n-_-GEOR0_mens-sneakers"))
		when "sweaters"
		@model_type = "sweaters-sweater-vests"
		@model_id = 10258
		@doc = Nokogiri::HTML(open("http://www1.bloomingdales.com/shop/mens/sweaters-sweater-vests?id=10258&cm_sp=categorysplash_men_men_1-_-row6_image_n-_-GEOR0_mens-sweaters"))
		when "bags"
		@model_type = "bags-briefcases"
		@model_id = 1000059
		@doc = Nokogiri::HTML(open("http://www1.bloomingdales.com/shop/mens/bags-briefcases?id=1000059&cm_sp=categorysplash_men_men_1-_-row7_image_n-_-GEOR0_mens-bags-%2526-briefcases"))
		when "watches"
		@model_type = "watches"
		@model_id = 1000066
		@doc = Nokogiri::HTML(open("http://www1.bloomingdales.com/shop/mens/watches?id=1000066&cm_sp=categorysplash_men_men_1-_-row7_image_n-_-GEOR0_mens-watches"))
		else 
		redirect_to products_path
		flash[:warning] = "Something went wrong"
	end

	# For Blooming Dales the intial selector is named different for these two product types.
	if type == "dress shoes" || type == "sneakers"
		@selector = "#row3_column1"
	else
		@selector = "#row2_column1"
	end
end


def create 
	 product = current_user.products.build(product_params)
end

	      def get_products
	      get_type()
	      # This query is prefomed to create four needed variables.
	      # Current_page is the First Page we initial query. 
	      # Total Items is a string ie "100 products" this string then gets parsed for all Numbers in the string and then set as Total_number.
	      # Number of Pages is needed to know how many pages we should have parsed
	      @doc.css(@selector).find_each do |result|
	        @first_page = (result.css(".currentPage").text[-1]).to_i
	        total_items = result.css('#productCount').text.strip
	        @total_number = total_items.scan(/\d/).join('')
	        @number_of_pages = (@total_number.to_f / 90).round
	      end 

	    # These values are initalized to start the algorithm .   
	    next_page = 1
	    item_count = 0
	    count = 0

	    # Currently a Guest User is created for api queries/ although you can also query by user id.
	   
	    # This is the recursive method that will preform a parse on every page on the scraped site.
	


	    traverse = lambda do |page|
	    # BaseCase for escaping recursive function
	    # After item count is equal to the total number of products we should have collected
	      if item_count == @total_number.to_f
	        return
	      end
	    
	      # This method will create a product model from elements parsed by the Nokogiri. 
	      @doc.css(@selector).find_each do |result|
	        result.css(".thumbnailItem").find_each do |product|
	          @product = Product.create
	          @product.description = product.at_css("#prodName").text
	          @product.brand = product.at_css("#brandName").text
	          @product.remote_image_url = product.at_css("img").attr('src')
	            if product.at_css(".prices").text.strip.include?("Sale")
	              @product.sale = true
	              @product.sale_price = product.at_css(".priceSale").text.strip
	           end
	              @product.price = product.at_css(".priceSale").text.strip
	          @product.save
	          item_count = item_count + 1
	          count = count + 1
	        end
	        next_page = page + 1
	      end
	      # At this point we reset the document needed to parse by Nokogiri with the next_page being increased by one.
	      @doc = Nokogiri::HTML(open("http://www1.bloomingdales.com/shop/mens/#{@model_type}/Pageindex/#{next_page}?id=#{@model_id}"))
	      count = 0
	      traverse.call(next_page)
	    end

	#Calling the helper method on the first page
	traverse.call(@first_page)
	 redirect_to products_path 
	end    

	def destroy
	    product = current_user.products.find(params[:id])
	    product.destroy
	    head 204
  	end

	def destroy_all
		
	
  	end


	private


	    def restrict_access
	  api_key = ApiKey.find_by_access_token(params[:token])
        head :unauthorized unless api_key
	    end

		def product_params
			params.require(:product).permit(:image, :price, :brand, :description, :sale, :sale_price)
		end

	end
end