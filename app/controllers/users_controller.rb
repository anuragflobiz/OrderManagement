class UsersController < ApplicationController
  before_action :set_user
  before_action :authorize_user!

  def show
    render_success(
      @user.slice(:id, :name, :email, :phone_number, :role)
    )
  end

  def update
    user = UserService.update(@user, user_params)

    render_success(
      user.slice(:id, :name, :email, :phone_number),
      "Profile updated successfully"
    )
  end

  def destroy
    UserService.destroy(@user)
    render_success(nil, "Account deleted successfully")
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_user!
    raise CustomErrors::Forbidden, "Access denied" unless @user.id == current_user.id
  end

  def user_params
    params.permit(:name, :phone_number)
  end
end