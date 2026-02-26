class RemoveIncoorectIndex < ActiveRecord::Migration[5.2]
  def change
    remove_index :items, :name if index_exists?(:items, :name)
  end
end
