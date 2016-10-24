class ProductsController < ApplicationController

  def index
    if current_user != nil
      @user = User.find_by_id(current_user.id)
      @products = current_user.products.paginate(:page => params[:page], :per_page => 90)
    
    end
  end

  def new
  	@product = Product.new(params[:product_params])
  end

  def show
  	@product = Product.find_by_id(params[:id])
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

  def save_to_user(product)
      if current_user.products == nil
        current_user.products = []
      end
      current_user.products << product
  end

  def create
     
  end

  def get_products
    get_type()
      # This query is prefomed to create four needed variables.
      # Current_page is the First Page we initial query. 
      # Total Items is a string ie "100 products" this string then gets parsed for all Numbers in the string and then set as Total_number.
      # Number of Pages is needed to know how many pages we should have parsed
      @doc.css(@selector).each do |result|
        @first_page = (result.css(".currentPage").text[-1]).to_i
        total_items = result.css('#productCount').text.strip
        @total_number = total_items.scan(/\d/).join('')
        number_of_pages = (@total_number.to_f / 90).round

      end 

    # These values are initalized to start the algorithm .   
    next_page = 1
    item_count = 0
    count = 0

    # This is the recursive method that will preform a parse on every page on the scraped site.
    traverse = lambda do |page|
      if item_count >= @total_number.to_f
        return
      end
      
      # This method will create a product model from elements parsed by the Nokogiri. 
      @doc.css(@selector).each do |result|
        result.css(".thumbnailItem").each do |product|
        
          @product =  @product = Product.create(params[:product_params])
         
          @product.user_id = current_user.id
          @product.description = product.at_css("#prodName").text
          @product.brand = product.at_css("#brandName").text
          @product.original_image_url = product.at_css("img").attr('src')
          @product.remote_image_url = product.at_css("img").attr('src')
           @product.price = product.at_css(".priceSale").text.strip
            if product.at_css(".prices").text.strip.include?("Sale")
              @product.sale = true
              @product.sale_price = product.at_css(".priceSale").text.strip
            end
            @product.save
           save_to_user(@product)
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
    if @product.user_id = current_user.id
    	@product = Product.find_by_id(params[:id])
      @product.destroy
      flash[:success] = "Product deleted"
      redirect_to products_path
    else
        flash[:warning] = "Nice Try!"
        redirect_to  products_path
      end
  end

  def destroy_all
     @products = current_user.products
     
    @products.destroy_all
    redirect_to products_path
  end

private

	def product_params
		 params.require(:product).permit(:image, :price, :brand, :description, :sale, :sale_price, :original_image_url, :user_id, :collection_id, :color, :type)
	end

end
