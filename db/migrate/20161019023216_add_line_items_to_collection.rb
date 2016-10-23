class AddLineItemsToCollection < ActiveRecord::Migration[5.0]
  def change
    add_column :collections, :line_items, :text
  end
end
