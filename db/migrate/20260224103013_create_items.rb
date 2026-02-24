class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :name
      t.decimal :price, precision: 10, scale: 2
      t.integer :quantity
      t.references :user, foreign_key: true
      t.integer :lock_version
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
