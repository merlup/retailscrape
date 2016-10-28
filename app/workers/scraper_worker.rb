class ScraperWorker
  include Sidekiq::Worker
  require 'nokogiri'
  sidekiq_options queue: 'critical'
 sidekiq_options retry: false

  def perform(store,shopping_from,selector,model_type,model_id,model_section,current_user_id)
    owner_id = current_user_id

    if store == "Bloomingdales"
      doc = Nokogiri::HTML(open("http://#{shopping_from}/shop/#{model_section}/#{model_type}/Pageindex/1?id=#{model_id}"))
    end


    if store == "Macys"
      doc = Nokogiri::HTML(open("http://#{shopping_from}/shop/#{model_section}/#{model_type}/Pageindex/1?id=#{model_id}"))
    end

      # This query is prefomed to create four needed variables.
      # Current_page is the First Page we initial query. 
      # Total Items is a string ie "100 products" this string then gets parsed for all Numbers in the string and then set as Total_number.
      # Number of Pages is needed to know how many pages we should have parsed
      if store == "Bloomingdales"
        p "Found"
        doc.css(selector).each do |result|  
          total_items = result.css('#productCount').text.strip
          @total_number = total_items.scan(/\d/).join('')
          @number_of_pages = (@total_number.to_f / 90).round
        end
      end 

    

    next_page = 1
    item_count = 0


    if store == "Bloomingdales"
      p "Looping Bloomingdales"
      doc = Nokogiri::HTML(open("http://#{shopping_from}/shop/#{model_section}/#{model_type}/Pageindex/#{next_page}?id=#{model_id}"))
      while item_count <= @total_number.to_f
       doc.css(selector).each do |result|
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

      if store == "Macys"
        doc = Nokogiri::HTML(open("http://#{shopping_from}/shop/#{model_section}/#{model_type}/Pageindex/#{next_page}?id=#{model_id}"))
      
        doc.css('#browse_womens_default_pageRegion').each do |result|
          total_items = result.css('#productCount').text
          @total_number = total_items.scan(/\d/).join('')
          @number_of_pages = (@total_number.to_f / 60).round
         
        end
        
      end

     
 if store == "Macys"
      p "Looping MAcys"
       
      doc = Nokogiri::HTML(open("http://#{shopping_from}/shop/#{model_section}/#{model_type}/Pageindex/#{next_page}?id=#{model_id}"))
      while item_count <= @total_number.to_f
       doc.css(selector).each do |result|
          result.css(".borderless").each do |product|
            
            @product = Product.new
            @product.user_id =  owner_id
            @product.description = product.at_css(".shortDescription").text
            @product.brand = product.at_css(".shortDescription").text
            @product.original_image_url = product.at_css(".thumbnailMainImage").attr('src')
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


  end

end