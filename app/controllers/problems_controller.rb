class ProblemsController < MemberController

  def index
    @problems = Problem.page(params[:page])
  end

  def aoj
    aoj = Aoj::Session.new
    aoj_user = aoj.create(params[:name], params[:password])
    if aoj_user.present? && current_user.update(aoj_user)
      flash[:notice] = 'AOJにログイン成功しました。ユーザデータを更新しました。'
    else
      flash[:error] = 'AOJにログイン失敗しました。'
    end
    redirect_to problems_path
  end
end
