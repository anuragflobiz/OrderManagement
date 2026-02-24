class Message < ApplicationRecord
  belongs_to :user
  belongs_to :message_template
  
  enum status: { pending: 0, sent: 1, failed: 2 }
  
  validates :notification_template_id, presence: true
  
  scope :active, -> { where(deleted_at: nil) }
end
