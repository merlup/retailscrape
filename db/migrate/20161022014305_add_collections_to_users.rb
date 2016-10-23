class AddCollectionsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :collections, :text
  end
end
