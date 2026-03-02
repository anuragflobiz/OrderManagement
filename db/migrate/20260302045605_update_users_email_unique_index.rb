class UpdateUsersEmailUniqueIndex < ActiveRecord::Migration[5.2]
  def change

    remove_index :users, :email


    add_index :users,:email, unique: true, where: "deleted_at IS NULL",name: "index_users_on_email_active"
  end
end