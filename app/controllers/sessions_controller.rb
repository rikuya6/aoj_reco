class SessionsController < ApplicationController

  def create
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      if user.administrator?
        redirect_to :admin_root
      else
        redirect_back_or edit_user_path(user.id)
      end
      flash[:notice] = 'ログインしました。'
    else
      flash[:alert] = 'メールアドレスとパスワードが一致しません'
      redirect_to :root
    end
  end

  def destroy
    session.delete(:user_id)
    cookies.clear
    flash[:notice] = 'ログアウトしました。'
    redirect_to :root
  end
end
