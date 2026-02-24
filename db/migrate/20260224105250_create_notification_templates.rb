class CreateNotificationTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :notification_templates do |t|
      t.string :name
      t.text :body

      t.timestamps
    end
  end
end
