class User < ApplicationRecord
  include SoftDelete
  has_secure_password

  has_many :orders, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :messages, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :password, presence: true, on: :create

  enum role: { retailer: 0, customer: 1 }

  def retailer?
    role == 'retailer'
  end
  
  def customer?
    role == 'customer'
  end
end
