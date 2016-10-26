json.array!(@line_items) do |line_item|
  json.extract! line_item, :id, :brand, :price, :sale, :description, :sale_price, :collection_id,  :image

  json.url line_item_url(line_item, format: :json)
end
