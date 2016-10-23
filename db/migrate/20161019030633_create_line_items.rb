class CreateLineItems < ActiveRecord::Migration[5.0]
  def change
    create_table :line_items do |t|
      t.string :brand
      t.string :price
      t.string :description
      t.string :sale_price
      t.string :type
      t.boolean :sale
      t.string :image
      t.belongs_to :collection, foreign_key: true
      t.timestamps
    end
  end
end
