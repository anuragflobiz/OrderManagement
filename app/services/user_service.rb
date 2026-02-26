class UserService
  def self.update(user, params)
    if user.update(params)
      {
        success: true,
        user: user.slice(:id, :name, :email, :phone_number)
      }
    else
      {
        success: false,
        message: user.errors.full_messages.join(', ')
      }
    end
  end
end