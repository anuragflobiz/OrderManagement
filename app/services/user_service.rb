class UserService
  def self.update(user, params)
    user.update!(params)
    user
  end

  def self.destroy(user)
    user.destroy!
  end
end