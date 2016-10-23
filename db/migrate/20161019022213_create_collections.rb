class CreateCollections < ActiveRecord::Migration[5.0]
  def change
    create_table :collections do |t|
    t.string :client
    t.string :line_items
    t.integer :user_id
      t.timestamps
    end

  end
end
