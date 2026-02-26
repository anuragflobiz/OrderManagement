class AddMissingIndexesToOrderManagement < ActiveRecord::Migration[5.2]
  def change
   
    add_index :users, :email, unique: true unless index_exists?(:users, :email)
    add_index :items, :user_id unless index_exists?(:items, :user_id)
    add_index :items, :name, using: :btree unless index_exists?(:items, :name)
    add_index :items, [:user_id, :name] unless index_exists?(:items, [:user_id, :name])
    add_index :orders, :user_id unless index_exists?(:orders, :user_id)
    add_index :item_orders, :order_id unless index_exists?(:item_orders, :order_id)
    add_index :item_orders, :item_id unless index_exists?(:item_orders, :item_id)
    add_index :item_orders, [:order_id, :item_id] unless index_exists?(:item_orders, [:order_id, :item_id])
    add_index :messages, :user_id unless index_exists?(:messages, :user_id)
  end
end