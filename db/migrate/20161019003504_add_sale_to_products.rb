class AddSaleToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :sale, :boolean
  end
end
