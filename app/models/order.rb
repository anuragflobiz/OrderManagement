class Order < ApplicationRecord
  include SoftDelete
  belongs_to :user

  has_many :item_orders, dependent: :destroy
  has_many :items, through: :item_orders

  enum status: { pending: 0, confirmed: 1, cancelled: 2 }
  validates :amount, presence: true

  scope :active, -> { where(deleted_at: nil) }
end
