class ProblemsController < MemberController

  def edit
  end

  def update
    aoj = Aoj::Session.new
    if params[:aoj_id].present? && params[:aoj_password].present?
      aoj_user = aoj.create(params[:aoj_id], params[:aoj_password])
    end
    if aoj_user.present? && current_user.update(aoj_user)
      update_user_problems!(aoj)
      aoj.destroy
      flash[:notice] = 'AOJにログイン成功しました。データを更新しました。'
      redirect_to root_path
    else
      flash[:error] = 'AOJにログイン失敗しました。'
      redirect_to edit_problem_path
    end
  end

  def recommend
    @recommend = Problem.recommend(current_user)
  end


  private

  def update_user_problems!(aoj_session)
    return unless current_user.changed
    current_user.changed = false
    aoj_p = Aoj::Problem.new
    aoj_p.set_cookies!(aoj_session.get_cookies)
    vlist = aoj_p.get_volume_list
    vlist.each do |volume_id|
      codes = aoj_p.get_user_solved_problem_codes(volume_id)
      codes.each do |code|
        user_problem = current_user.user_problems.find_or_initialize_by(problem_id: Problem.find_by(code: code).id)
        user_problem.update_attributes({ solved: true })
      end
      # break # @TODO 暫定 開発中のみ
    end
  end
end
