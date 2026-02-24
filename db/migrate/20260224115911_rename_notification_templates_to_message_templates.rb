class RenameNotificationTemplatesToMessageTemplates < ActiveRecord::Migration[5.2]
  def change
    rename_table :notification_templates, :message_templates
  end
end
