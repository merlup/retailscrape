class ScraperWorker
  include Sidekiq::Worker
  require 'nokogiri'
  sidekiq_options queue: 'critical'
 sidekiq_options retry: false

  def perform(selector,doc,model_type,model_id,model_section,current_user_id)
    owner_id = current_user_id

    doc = Nokogiri::HTML(open("http://www1.bloomingdales.com/shop/#{model_section}/#{model_type}/Pageindex/1?id=#{model_id}"))
    
      # This query is prefomed to create four needed variables.
      # Current_page is the First Page we initial query. 
      # Total Items is a string ie "100 products" this string then gets parsed for all Numbers in the string and then set as Total_number.
      # Number of Pages is needed to know how many pages we should have parsed
      doc.css(selector).each do |result|
        @first_page = (result.css(".currentPage").text[-1]).to_i
        total_items = result.css('#productCount').text.strip
        @total_number = total_items.scan(/\d/).join('')
        @number_of_pages = (@total_number.to_f / 90).round
      end 

    next_page = 1
    item_count = 0
    doc = Nokogiri::HTML(open("http://www1.bloomingdales.com/shop/#{model_section}/#{model_type}/Pageindex/#{next_page}?id=#{model_id}"))
   
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

end