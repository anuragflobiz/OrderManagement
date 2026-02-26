class AddBtreeIndex < ActiveRecord::Migration[5.2]
  def change
    unless index_exists?(:items, name: "index_items_on_lower_name")
      add_index :items,"lower(name)",name: "index_items_on_lower_name",using: :btree
    end
  end
end