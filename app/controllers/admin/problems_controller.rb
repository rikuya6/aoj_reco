class Admin::ProblemsController < Admin::Base

  def index
    @problems = Problem.page(params[:page])
  end

  def edit
    @problem = Problem.find(params[:id])
  end

  def update
    @problem = Problem.find(params[:id])
    @problem.assign_attributes(problem_params)
    if @problem.save
      redirect_to admin_problems_path, notice: '問題を更新しました。'
    else
      render 'edit'
    end
  end

  def destroy
    @problem = Problem.find(params[:id])
    @problem.destroy
    redirect_to admin_problems_path, notice: '問題を削除しました。'
  end

  private

  def problem_params
    attrs = [:code, :name, :time_limit, :mmemory_limit, :solved_user, :submissions, :success_rate, :vlolume, :large_cl, :difficulty]
    params.require(:problem).permit(attrs)
  end
end
