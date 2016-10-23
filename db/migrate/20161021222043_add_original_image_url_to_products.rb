class AddOriginalImageUrlToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :original_image_url, :string
  end
end
