class SessionController < ApplicationController
  skip_before_action :require_login, only: [:login, :create]

  def login; end

  def create
    user = User.find_by_email(params[:email])

    if user&.authenticate(params[:password])
      sign_in user
      redirect_to root_path
    else
      flash.now[:danger] = "Неверный логин или пароль."
      redirect_to session_login_path
    end
  end

  def logout
    cookies.permanent[:remember_token] = nil
    redirect_to session_login_path
  end

end
