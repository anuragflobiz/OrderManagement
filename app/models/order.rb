class Order < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  has_many :item_orders
  has_many :items, through: :item_orders

  enum status: { pending: 0, confirmed: 1, cancelled: 2 }

  validates :amount, presence: true
end