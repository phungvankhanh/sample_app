class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find_by id: params[:id]
    return unless !@user
    flash[:danger] = t "controllers_users.danger"
    redirect_to root_path
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "controllers_users.welcome"
      redirect_to @user
    else
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end
end
