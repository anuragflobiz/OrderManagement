class Message < ApplicationRecord

  include SoftDelete
  belongs_to :user
  belongs_to :message_template
  
  enum status: {  sent: 0, failed: 1 }
  
  validates :message_template_id, presence: true
  
  scope :active, -> { where(deleted_at: nil) }
end
