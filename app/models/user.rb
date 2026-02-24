class User < ApplicationRecord
  has_secure_password

  has_many :orders, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :messages, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :password, presence: true

  scope :active, -> { where(:deleted_at => nil)}
end
