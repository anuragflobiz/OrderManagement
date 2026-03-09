class User < ApplicationRecord
  acts_as_paranoid
  has_secure_password

  has_many :orders
  has_many :items
  has_many :messages

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :password, length: { minimum: 9 }, allow_nil: true

  enum role: { retailer: 0, customer: 1 }

  before_save { self.email = email.downcase }
end