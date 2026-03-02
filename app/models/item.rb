class Item < ApplicationRecord
  acts_as_paranoid
  belongs_to :user
  has_many :item_orders
  has_many :orders, through: :item_orders
  validates :name, :price, :quantity, presence: true

  scope :low_stock, -> { where('quantity < ?', 10) }
  scope :out_of_stock, -> { where(quantity: 0) }

  def available?
    quantity > 0 && !deleted?
  end
end
