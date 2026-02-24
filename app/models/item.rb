class Item < ApplicationRecord
  belongs_to :user
  has_many :item_orders, dependent: :destroy
  has_many :orders, through: :item_orders
  validates :name, :price, :quantity, presence: true

  scope :active, -> { where(deleted_at: nil) }
  scope :low_stock, -> { active.where('quantity < ?', 10) }
  scope :out_of_stock, -> { active.where(quantity: 0) }
end
