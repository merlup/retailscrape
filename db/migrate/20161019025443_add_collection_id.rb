class AddCollectionId < ActiveRecord::Migration[5.0]
  def change
  	add_column :products, :collection_id, :integer
  end
end
