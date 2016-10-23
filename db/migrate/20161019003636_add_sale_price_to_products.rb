class AddSalePriceToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :sale_price, :string
  end
end
