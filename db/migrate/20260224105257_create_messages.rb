class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.references :user, foreign_key: true
      t.references :notification_template, foreign_key: true
      t.jsonb :metadata
      t.integer :status
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
