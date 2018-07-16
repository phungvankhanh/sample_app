class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :find_user, only: [:show, :show, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.select_things.paginate page: params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".please_check_mail"
      redirect_to root_url
    else
      render :new
    end
  end

  def show
    if @user && @user.activated
      @microposts = @user.microposts.paginate page: params[:page]
    else
      redirect_to root_url
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".update"
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = ".destroy"
    redirect_to users_url
  end

  private
  def find_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t ".user_not_found"
    redirect_to root_path
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t ".logged_in_user"
    redirect_to login_url
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
