class Admin::UsersController < Admin::Base

  def index
    @users = User.page(params[:page])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    return render 'edit' # @TODO 暫定: 更新すべき項目が未決定のため。
    @user.assign_attributes(user_params)
    if @user.save
      redirect_to admin_users_path, notice: 'ユーザを更新しました。'
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path, notice: 'ユーザを削除しました。'
  end

  private

  def user_params
    attrs = []
    params.require(:user).permit(attrs)
  end
end
