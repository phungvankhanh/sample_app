class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user && user.authenticate(params[:session][:password])
      condition_auth user
    else
      flash.now[:danger] = t ".invalid_email_pass"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private
  def remember_user user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
  end

  def condition_auth user
    if user.activated?
      log_in user
      remember_user user
      redirect_back_or user
    else
      message  = t ".account_not_activated"
      message += t ".check_your_email"
      flash[:warning] = message
      redirect_to root_url
    end
  end
end
