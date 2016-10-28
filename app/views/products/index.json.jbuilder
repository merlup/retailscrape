json.array!(@products) do |product|
  json.extract! product, :id, :brand, :price, :sale, :description, :sale_price, :original_image_url

  json.url product_url(product, format: :json)
end
