class TopController < GuestController

  def index
    @problems = Problem.order(:id).page(params[:page])
  end

  def about
  end

  def recommend
    user = User.find_by(code: params[:code])
    return redirect_to :root, alert: "#{params[:code]}は見つかりませんでした。" if user.blank?
    @recommends = Problem.recommend user
  end

  def not_found
    raise ActionController::RoutingError, "No route matches #{request.path.inspect}"
  end

  def bad_request
    raise ActionController::ParameterMissing, ''
  end

  def internal_server_error
    raise Exception
  end
end
