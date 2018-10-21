class MemberController < ApplicationController
  before_action :login_required

  # プライベートメソッド
  private

  def login_required
    save_location
    redirect_to :root, notice: 'ログインしてください。' unless current_user
  end

  def user_authorization
    @user = User.find_by(id: params[:user_id])
    @user ||= User.find_by(id: params[:id]) if @user.nil?
    redirect_to :root unless @user == current_user
  end
end
