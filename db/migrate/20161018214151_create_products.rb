class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :price
      t.string :brand
      t.string :description
      t.string :color
      t.string :type
      t.integer :user_id
      t.string :image
      t.string :original_image_url
      t.boolean :sale
      t.string :sale_price
      t.timestamps
    end
     
  end
end
