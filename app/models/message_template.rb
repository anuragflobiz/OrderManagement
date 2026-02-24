class MessageTemplate < ApplicationRecord

  has_many :messages
  
  validates :name, presence: true, uniqueness: true
  validates :body, presence: true
end
