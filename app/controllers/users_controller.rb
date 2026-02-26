class UsersController < ApplicationController
  include Authentication

  before_action :set_user
  before_action :authorize_user!

  def show
    render_success(@user.as_json(only: [:id, :name, :email, :phone_number, :role]))
  end

  def update
    result = UserService.update(@user, user_params)

    if result[:success]
      render json: result
    else
      render json: result, status: :unprocessable_entity
    end 
  end

  def destroy
    @user.destroy
    render_success(nil, "Account deleted")
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_user!
    render_forbidden('Access denied') unless @user.id == current_user.id
  end

  def user_params
    params.permit(:name, :phone_number)
  end
end