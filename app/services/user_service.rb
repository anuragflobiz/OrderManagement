class UserService
  def self.update(user, params)
    user.update!(params)
    user
  end

  def self.destroy(user)
    ActiveRecord::Base.transaction do
      delete_items(user) if user.retailer?
      user.destroy!
    end
  end

  private

  def self.delete_items(user)
    Item.where(user_id: user.id).update_all(deleted_at: Time.current)
  end
end