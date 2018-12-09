class Admin::SessionsController < Admin::Base

  def new
  end

  def create
    admin = Admin.find_by(name: params[:name])
    if admin && admin.authenticate(params[:password])
      session[:admin_id] = admin.id
      flash[:notice] = 'ログインしました。'
      redirect_to :admin_problems
    else
      flash[:alert] = 'メールアドレスとパスワードが一致しません'
      redirect_to admin_new_login_path
    end
  end

  def destroy
    session.delete(:admin_id)
    cookies.clear
    flash[:notice] = 'ログアウトしました。'
    redirect_to :admin_root
  end
end
