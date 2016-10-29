class ProductsController < ApplicationController

  def index
    if current_user != nil
      @skip_header = true
      if current_user.products.length <= 0
        @products = []
      else
        @products = current_user.products

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
@store = params[:store]
    # The below case method creates two variables. Model Type & Model ID which are later needed to query multiple pages on the scraped website. 
    # Doc is short for document which is Nokogiri uses to parse.
    case type
      when "jeans"
        @store = params[:store]
         @model_section = "mens"
         @selector = "#browse_womens_default_product"
        if @store == "Macys"
           @store = params[:store]
          @shopping_from = "www1.macys.com"
          @model_section = "mens-clothing"
          @model_type = "mens-jeans"
          @model_id = 11221
          @selector = "#browse_womens_default_product" 
          else
            @model_section = "mens"
           @shopping_from = "www1.bloomingdales.com"
          @model_type = "jeans"
          @model_id = 10172
          @selector = "#row3_column1"
        end  
      when "coats-jackets"
      @model_section = "mens"
         if @store == "Macys"
           @shopping_from = "www1.macys.com"
             @selector = "#browse_womens_default_product" 
          else
        @shopping_from = "www1.bloomingdales.com"
        @model_type = "coats-jackets"
        @model_id = 11548
         @selector = "#row3_column1" 
        end  
      when "button-downs"
        @model_section = "mens"
         if @store == "Macys"
           @shopping_from = "www1.macys.com"
             @selector = "#browse_womens_default_product" 
          else
         @shopping_from = "www1.bloomingdales.com"  
        @model_type = "casual-button-down-shirts"
        @model_id = 17648
        @selector = "#row3_column1"
          
        end  
     when "suits-tux"
        @model_section = "mens"
       if @store == "Macys"
         @model_section = "mens-clothing"
        @model_type = 'mens-suits'  
        @selector = "#browse_womens_default_product" 
        @model_id = 17788
           @shopping_from = "www1.macys.com"
          else
         @shopping_from = "www1.bloomingdales.com"   
        @model_type = "suits-tuxedos"
        @model_id = 1003462
        @selector = "#row3_column1" 
        end  
     when "belts"
       @model_section = "mens"
       if @store == "Macys"
           @shopping_from = "www1.macys.com"  
           @selector = "#browse_womens_default_product" 
          else
          @shopping_from = "www1.bloomingdales.com"     
        @model_type = "mens-designer-belts"
        @model_id = 1000060
        @selector = "#row3_column1" 
        end  
     when "dress-shoes"
      @model_section = "mens"
       if @store == "Macys"
        @model_type = "shop-all-mens-footwear"  
        @selector = "#browse_womens_default_product" 
           @shopping_from = "www1.macys.com"
           @model_id = 55822
          else
        @shopping_from = "www1.bloomingdales.com"        
        @model_type = "dress-shoes"
        @model_id = 1001183
         @selector = "#row3_column1"
        end  
     when "sneakers"
      @model_section = "mens"
       if @store == "Macys"
           @shopping_from = "www1.macys.com"  
           @selector = "#browse_womens_default_product" 
          else
         @shopping_from = "www1.bloomingdales.com"     
        @model_type = "sneakers-athletic"
        @model_id = 1000054
         @selector = "#row3_column1"
        end  
     when "sweaters"
      @model_section = "mens"
       if @store == "Macys"
           @shopping_from = "www1.macys.com"  
           @selector = "#browse_womens_default_product" 
          else
         @shopping_from = "www1.bloomingdales.com"    
        @model_type = "sweaters-sweater-vests"
        @model_id = 10258
        @selector = "#row3_column1" 
        end  
     when "bags"
       @model_section = "mens"
       if @store == "Macys"
           @shopping_from = "www1.macys.com"  
           @selector = "#browse_womens_default_product" 
          else
         @shopping_from = "www1.bloomingdales.com"    
        @model_type = "bags-briefcases"
        @model_id = 1000059
         @selector = "#row3_column1" 
        end 
     when "watches"
      @model_section = "mens"
       if @store == "Macys"
           @shopping_from = "www1.macys.com" 
            @selector = "#browse_womens_default_product" 
          else
          @shopping_from = "www1.bloomingdales.com"      
        @model_type = "watches"
        @model_id = 1000066
        @selector = "#row1_column1"
          
        end  
      when "dresses"
        @model_section = "womens-apparel"
         if @store == "Macys"
           @shopping_from = "www1.macys.com" 
           @selector = "#browse_womens_default_product" 
          else
         @shopping_from = "www1.bloomingdales.com"    
        @model_type = "dresses"
        @model_id = 21683
        @selector = "#row2_column1"
          
        end  
      when "coats"
      @model_section = "womens-apparel"
         if @store == "Macys"
           @shopping_from = "www1.macys.com"  
           @selector = "#browse_womens_default_product" 
          else  
         @shopping_from = "www1.bloomingdales.com"    
        @model_type = "coats"
        @model_id = 1001520
        @selector = "#row2_column1"
          
        end  
      when "womens-jeans"
        @model_section = "womens-apparel"
         if @store == "Macys"
           @shopping_from = "www1.macys.com"  
           @selector = "#browse_womens_default_product" 
          else
        @shopping_from = "www1.bloomingdales.com"
        @model_type = "jeans"
        @model_id = 5545
        @selector = "#row2_column1"  
        end 
      when "tops-tees"
      @model_section = "womens-apparel"
         if @store == "Macys"
           @shopping_from = "www1.macys.com"  
           @selector = "#browse_womens_default_product" 
          else
          @shopping_from = "www1.bloomingdales.com"   
        @model_type = "tops-tees"
        @model_id = 5619
        @selector = "#row2_column1"
      end  
      when "womens-sweaters"
        @model_section = "womens-apparel"
         if @store == "Macys"
           @shopping_from = "www1.macys.com"  
           @selector = "#browse_womens_default_product" 
          else
          @shopping_from = "www1.bloomingdales.com"   
          @model_type = "sweaters"
          @model_id = 12374
          @selector = "#row2_column1"
        end  
      when "active-workout"
      @model_section = "womens-apparel"
         if @store == "Macys"
           @shopping_from = "www1.macys.com" 
            @selector = "#browse_womens_default_product" 
          else
        @shopping_from = "www1.bloomingdales.com"    
        @model_type = "activewear-workout-clothes"
        @model_id = 11817
       @selector = "#row2_column1"
        end
      when "jackets"
        @model_section = "womens-apparel"
         if @store == "Macys"
           @shopping_from = "www1.macys.com"  
           @selector = "#browse_womens_default_product" 
          else
          @shopping_from = "www1.bloomingdales.com"   
        @model_type = "jackets-blazers"
        @model_id = 1001521
        @selector = "#row2_column1"
        end  
      when "skirts"
        @model_section = "womens-apparel"
         if @store == "Macys"
           @shopping_from = "www1.macys.com"  
           @selector = "#browse_womens_default_product" 
          else
        @shopping_from = "www1.bloomingdales.com" 
        @model_type = "skirts"
        @model_id = 19951
        @selector = "#row2_column1"
        end  
      
       
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

    next_page = 1
    item_count = 0
    owner_id = current_user.id

    if @store == "Bloomingdales"
      @doc = Nokogiri::HTML(open("http://#{@shopping_from}/shop/#{@model_section}/#{@model_type}/Pageindex/#{@next_page}?id=#{@model_id}"))
    end

      # This query is prefomed to create four needed variables.
      # Current_page is the First Page we initial query. 
      # Total Items is a string ie "100 products" this string then gets parsed for all Numbers in the string and then set as Total_number.
      # Number of Pages is needed to know how many pages we should have parsed
      if @store == "Bloomingdales"
        p "Found"
        @doc.css(@selector).each do |result|  
          total_items = result.css('#productCount').text.strip
          @total_number = total_items.scan(/\d/).join('')
          @number_of_pages = (@total_number.to_f / 90).round
        end
      end


    if @store == "Bloomingdales"
      p "Looping Bloomingdales"
      @doc = Nokogiri::HTML(open("http://#{@shopping_from}/shop/#{@model_section}/#{@model_type}/Pageindex/#{@next_page}?id=#{@model_id}"))
      while item_count <= @total_number.to_f
       @doc.css(@selector).each do |result|
          result.css(".thumbnailItem").each do |product|
            
            @product = Product.new
            @product.user_id =  owner_id
            @product.description = product.at_css("#prodName").text
            @product.brand = product.at_css("#brandName").text
            @product.original_image_url = product.at_css("img").attr('src')
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
    end


      if @store == "Macys"
        @doc = Nokogiri::HTML(open("http://#{@shopping_from}/shop/#{@model_section}/#{@model_type}/Pageindex/#{@next_page}?id=#{@model_id}"))
      
        @doc.css('#browse_womens_default_pageRegion').each do |result|
          total_items = result.css('#productCount').text
          @total_number = total_items.scan(/\d/).join('')
          @number_of_pages = (@total_number.to_f / 60).round
         
        end
        
      end

 if @store == "Macys"
      p "Looping MAcys"
       
      @doc = Nokogiri::HTML(open("http://#{@shopping_from}/shop/#{@model_section}/#{@model_type}/Pageindex/#{@next_page}?id=#{@model_id}"))
      while item_count <= @total_number.to_f
       @doc.css(@selector).each do |result|
          result.css(".borderless").each do |product|
          
            @product = Product.new
            @product.user_id =  owner_id
            @product.description = product.at_css(".shortDescription").text
            @product.brand = product.at_css(".shortDescription").text
            @product.original_image_url = (product.at_css("img").attr('data-src'))
            @product.price = product.at_css(".first-range").text.strip
              if product.at_css(".prices").text.strip.include?("Sale")
                @product.sale = true
                @product.sale_price = product.at_css(".priceSale").text.strip
              end
            @product.save
 debugger
            item_count = item_count + 1
            next_page = next_page + 1
          end
        end
      end
    end
  p "$"*65, @shopping_from, @store, "$"*65
    #ScraperWorker.perform_async(@store,@shopping_from,@selector,@model_type,@model_id,@model_section,current_user.id)
  render json: @products
  end

def get_products_womens
  get_type()

    next_page = 1
    item_count = 0
    owner_id = current_user.id

    if @store == "Bloomingdales"
      @doc = Nokogiri::HTML(open("http://#{@shopping_from}/shop/#{@model_section}/#{@model_type}/Pageindex/#{@next_page}?id=#{@model_id}"))
    end

      # This query is prefomed to create four needed variables.
      # Current_page is the First Page we initial query. 
      # Total Items is a string ie "100 products" this string then gets parsed for all Numbers in the string and then set as Total_number.
      # Number of Pages is needed to know how many pages we should have parsed
      if @store == "Bloomingdales"
        p "Found"
        @doc.css(@selector).each do |result|  
          total_items = result.css('#productCount').text.strip
          @total_number = total_items.scan(/\d/).join('')
          @number_of_pages = (@total_number.to_f / 90).round
        end
      end


    if @store == "Bloomingdales"
      p "Looping Bloomingdales"
      @doc = Nokogiri::HTML(open("http://#{@shopping_from}/shop/#{@model_section}/#{@model_type}/Pageindex/#{@next_page}?id=#{@model_id}"))
      while item_count <= @total_number.to_f
       @doc.css(@selector).each do |result|
          result.css(".thumbnailItem").each do |product|
            
            @product = Product.new
            @product.user_id =  owner_id
            @product.description = product.at_css("#prodName").text
            @product.brand = product.at_css("#brandName").text
            @product.original_image_url = product.at_css("img").attr('src')
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
    end


      if @store == "Macys"
        @doc = Nokogiri::HTML(open("http://#{@shopping_from}/shop/#{@model_section}/#{@model_type}/Pageindex/#{@next_page}?id=#{@model_id}"))
      
        @doc.css('#browse_womens_default_pageRegion').each do |result|
          total_items = result.css('#productCount').text
          @total_number = total_items.scan(/\d/).join('')
          @number_of_pages = (@total_number.to_f / 60).round
         
        end
        
      end

 if @store == "Macys"
      p "Looping MAcys"
       
      @doc = Nokogiri::HTML(open("http://#{@shopping_from}/shop/#{@model_section}/#{@model_type}/Pageindex/#{@next_page}?id=#{@model_id}"))
      while item_count <= @total_number.to_f
       @doc.css(@selector).each do |result|
          result.css(".borderless").each do |product|
          
            @product = Product.new
            @product.user_id =  owner_id
            @product.description = product.at_css(".shortDescription").text
            @product.brand = product.at_css(".shortDescription").text
            @product.original_image_url = (product.at_css("img").attr('data-src'))
            @product.price = product.at_css(".first-range").text.strip
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
    end
  p "$"*65, @shopping_from, @store, "$"*65
    #ScraperWorker.perform_async(@store,@shopping_from,@selector,@model_type,@model_id,@model_section,current_user.id)
  render json: @products
  end

  def destroy_all
    @products = Product.all
    @products.destroy_all
    redirect_to products_path
  end

private

	def product_params
		 params.require(:product).permit(:price, :brand, :description, :sale, :sale_price, :original_image_url, :user_id, :collection_id, :color, :type)
	end

end
