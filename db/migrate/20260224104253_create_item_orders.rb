class CreateItemOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :item_orders do |t|
      t.references :item, foreign_key: true
      t.references :order, foreign_key: true
      t.integer :quantity
      t.decimal :item_price, precision: 10, scale: 2
      t.string :item_name
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
