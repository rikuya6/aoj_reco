class Admin::Base < ApplicationController
  before_action :admin_login_required
  layout 'layouts/admin/application'


  private

  def admin_login_required
    return if params[:controller] == 'admin/sessions' # ログイン・ログアウト処理時は無視する
    raise NotFound unless current_admin
  end
end
