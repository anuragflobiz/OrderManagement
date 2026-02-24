class FixMessageTemplateReferenceInMessages < ActiveRecord::Migration[5.2]
  def change
    if column_exists?(:messages, :notification_template_id)
      rename_column :messages,
                    :notification_template_id,
                    :message_template_id
    end
  end
end
