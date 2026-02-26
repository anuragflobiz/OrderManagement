class ItemOrder < ApplicationRecord

  include SoftDelete
  belongs_to :item
  belongs_to :order
end
