class ProductsController < ApplicationController

  def index
    if current_user != nil
      @skip_header = true
      if current_user.products.length <= 0
        @products = []
      else
        @products = current_user.products.order('created_at DESC').paginate( page: params[:page])
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
        @model_section = "mens"
        @model_type = "jeans"
        @model_id = 10172
         @selector = "#row3_column1"
      when "coats-jackets"
        @model_section = "mens"
        @model_type = "coats-jackets"
        @model_id = 11548
         @selector = "#row3_column1"
      when "button-downs"
        @model_section = "mens"
        @model_type = "casual-button-down-shirts"
        @model_id = 17648
         @selector = "#row3_column1"
     when "suits-tux"
      @model_section = "mens"
        @model_type = "suits-tuxedos"
        @model_id = 1003462
         @selector = "#row3_column1"
     when "belts"
      @model_section = "mens"
        @model_type = "mens-designer-belts"
        @model_id = 1000060
         @selector = "#row3_column1"
     when "dress-shoes"
      @model_section = "mens"
        @model_type = "dress-shoes"
        @model_id = 1001183
         @selector = "#row3_column1"
     when "sneakers"
      @model_section = "mens"
        @model_type = "sneakers-athletic"
        @model_id = 1000054
         @selector = "#row3_column1"
     when "sweaters"
      @model_section = "mens"
        @model_type = "sweaters-sweater-vests"
        @model_id = 10258
         @selector = "#row3_column1"
     when "bags"
      @model_section = "mens"
        @model_type = "bags-briefcases"
        @model_id = 1000059
         @selector = "#row3_column1"
     when "watches"
      @model_section = "mens"
        @model_type = "watches"
        @model_id = 1000066
        @selector = "#row1_column1"
      when "dresses"
        @model_section = "womens-apparel"
        @model_type = "dresses"
        @model_id = 21683
        @selector = "#row2_column1"
      when "coats"
        @model_section = "womens-apparel"
        @model_type = "coats"
        @model_id = 1001520
      @selector = "#row2_column1"
      when "womens-jeans"
        @model_section = "womens-apparel"
        @model_type = "jeans"
        @model_id = 5545
     @selector = "#row2_column1"
      when "tops-tees"
        @model_section = "womens-apparel"
        @model_type = "tops-tees"
        @model_id = 5619
        @selector = "#row2_column1"
      when "womens-sweaters"
        @model_section = "womens-apparel"
        @model_type = "sweaters"
        @model_id = 12374
        @selector = "#row2_column1"
      when "active-workout"
        @model_section = "womens-apparel"
        @model_type = "activewear-workout-clothes"
        @model_id = 11817
       @selector = "#row2_column1"
      when "jackets"
        @model_section = "womens-apparel"
        @model_type = "jackets-blazers"
        @model_id = 1001521
        @selector = "#row2_column1"
      when "skirts"
        @model_section = "womens-apparel"
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
    @doc = Nokogiri::HTML(open("http://www1.bloomingdales.com/shop/#{@model_section}/#{@model_type}/Pageindex/1?id=#{@model_id}"))
    ScraperWorker.perform_async(@selector,@doc,@model_type,@model_id,@model_section,current_user.id)
  render :nothing => true
  end

def get_products_womens
   get_type()
    @doc = Nokogiri::HTML(open("http://www1.bloomingdales.com/shop/#{@model_section}/#{@model_type}/Pageindex/1?id=#{@model_id}"))
    ScraperWorker.perform_async(@selector,@doc,@model_type,@model_id,@model_section,current_user.id)
render :nothing => true
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
