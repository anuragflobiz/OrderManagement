class ItemOrder < ApplicationRecord

  include SoftDeletable
  belongs_to :item
  belongs_to :order
end
