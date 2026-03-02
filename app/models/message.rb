class Message < ApplicationRecord

  belongs_to :user
  belongs_to :message_template
  
  enum status: { pending:0, sent: 1, failed: 2 }
  
  validates :message_template_id, presence: true
  
end