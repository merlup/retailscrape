class ProductsController < ApplicationController

  def index
    if current_user != nil
      @skip_header = true
      if current_user.products.length <= 0
        @products = []
      else
        @products = current_user.products.order('created_at ASC').paginate(per_page: 30, page: params[:page])
      end
    end
  end

  def new
  	@product = Product.create
  end

  def show
    if logged_in? && params[:id] == current_user.id
  	@product = Product.find_by_id(params[:id])
  else
    flash[:notice] = "Please Log in or stop doing that"
    redirect_to root_url
  end
  end

def get_type
  type = params[:type]

    # The below case method creates two variables. Model Type & Model ID which are later needed to query multiple pages on the scraped website. 
    # Doc is short for document which is Nokogiri uses to parse.
    case type
      when "jeans"
        @model_type = "jeans"
        @model_id = 10172
         @selector = "#row3_column1"
      when "coats-jackets"
        @model_type = "coats-jackets"
        @model_id = 11548
         @selector = "#row3_column1"
      when "button-downs"
        @model_type = "casual-button-down-shirts"
        @model_id = 17648
         @selector = "#row3_column1"
     when "suits-tux"
        @model_type = "suits-tuxedos"
        @model_id = 1003462
         @selector = "#row3_column1"
     when "belts"
        @model_type = "belts"
        @model_id = 1000060
         @selector = "#row3_column1"
     when "dress-shoes"
        @model_type = "dress-shoes"
        @model_id = 1001183
         @selector = "#row3_column1"
     when "sneakers"
        @model_type = "sneakers-athletic"
        @model_id = 1000054
         @selector = "#row3_column1"
     when "sweaters"
        @model_type = "sweaters-sweater-vests"
        @model_id = 10258
         @selector = "#row3_column1"
     when "bags"
        @model_type = "bags-briefcases"
        @model_id = 1000059
         @selector = "#row3_column1"
     when "watches"
        @model_type = "watches"
        @model_id = 1000066
        @selector = "#row1_column1"
      when "dresses"
        @model_type = "dresses"
        @model_id = 21683
        @selector = "#row2_column1"
      when "coats"
        @model_type = "coats"
        @model_id = 1001520
      @selector = "#row2_column1"
      when "womens-jeans"
        @model_type = "jeans"
        @model_id = 5545
     @selector = "#row2_column1"
      when "tops-tees"
        @model_type = "tops-tees"
        @model_id = 5619
        @selector = "#row2_column1"
      when "womens-sweaters"
        @model_type = "sweaters"
        @model_id = 12374
        @selector = "#row2_column1"
      when "active-workout"
        @model_type = "activewear-workout-clothes"
        @model_id = 11817
       @selector = "#row2_column1"
      when "jackets"
        @model_type = "jackets-blazers"
        @model_id = 1001521
        @selector = "#row2_column1"
      when "skirts"
        @model_type = "skirts"
        @model_id = 19951
        @selector = "#row2_column1"
     else 
       redirect_to products_path
       flash[:warning] = "Something went wrong"
    end

    # For Blooming Dales the intial selector is named different for these two product types.

      #@selector changesIf bloomingdales decides to run adds in a certain section. 


  end


  def create
     
  end

  def get_products_mens
    get_type()
     @doc = Nokogiri::HTML(open("http://www1.bloomingdales.com/shop/mens/#{@model_type}/Pageindex/1?id=#{@model_id}"))
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
     
    flash[:success] = "Getting #{@total_number.to_f} #{@type}'s' from Bloomingdales.com"

    next_page = 1
    item_count = 0
    @doc = Nokogiri::HTML(open("http://www1.bloomingdales.com/shop/mens/#{@model_type}/Pageindex/#{next_page}?id=#{@model_id}"))
 
    while item_count <= @total_number.to_f
     @doc.css(@selector).each do |result|
        result.css(".thumbnailItem").each do |product|
          @product = Product.create(params[:product_params])
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
        
          item_count = item_count + 1
          next_page = next_page + 1
        end
      end
    end
   redirect_to products_path
end

def get_products_womens
 
    get_type()
     @doc = Nokogiri::HTML(open("http://www1.bloomingdales.com/shop/womens-apparel/#{@model_type}/Pageindex/1?id=#{@model_id}"))
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
     
    flash[:success] = "Getting #{@total_number.to_f} #{@type}'s' from Bloomingdales.com"

    next_page = 1
    item_count = 0
    @doc = Nokogiri::HTML(open("http://www1.bloomingdales.com/shop/womens-apparel/#{@model_type}/Pageindex/#{next_page}?id=#{@model_id}"))
 
    while item_count <= @total_number.to_f
     @doc.css(@selector).each do |result|
     
        result.css(".thumbnailItem").each do |product|
          @product = Product.create(params[:product_params])
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
        
          item_count = item_count + 1
          next_page = next_page + 1
        end
      end
    end
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
    @products = Product.all
    @products.destroy_all
    redirect_to products_path
  end

private

	def product_params
		 params.require(:product).permit(:image, :price, :brand, :description, :sale, :sale_price, :original_image_url, :user_id, :collection_id, :color, :type)
	end

end
