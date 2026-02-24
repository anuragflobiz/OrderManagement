class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.decimal :amount, precision: 10, scale: 2
      t.references :user, foreign_key: true
      t.integer :status
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
