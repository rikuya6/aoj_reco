class ApplicationController < ActionController::Base
  before_action :set_locale

  class Forbidden < StandardError; end
  class NotFound < StandardError; end

  if Rails.env.production?
    rescue_from Exception,                          with: :rescue_500
    rescue_from ActionController::RoutingError,     with: :rescue_404
    rescue_from ActiveRecord::RecordNotFound,       with: :rescue_404
    rescue_from ActionController::ParameterMissing, with: :rescue_400
  end

  rescue_from Forbidden, with: :rescue_403
  rescue_from NotFound,  with: :rescue_404


  private

  def rescue_400(exception)
    render 'errors/bad_request', status: 400, layout: 'error', formats: [:html]
  end

  def rescue_403(exception)
    render 'errors/forbidden',   status: 403, layout: 'error', formats: [:html]
  end

  def rescue_404(exception)
    render 'errors/not_found',   status: 404, layout: 'error', formats: [:html]
  end

  def rescue_500(exception)
    render 'errors/internal_server_error', status: 500, layout: 'error', formats: [:html]
  end

  # def current_user
  #   @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  # end
  # helper_method :current_user

  def current_admin
    @current_admin ||= Admin.find_by(id: session[:admin_id]) if session[:admin_id]
  end
  helper_method :current_admin

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def redirect_back_or(default)
    redirect_to(session[:back_url] || default)
    session.delete(:back_url)
  end

  def save_location
    session[:back_url] = request.url if request.get?
  end

  def login_required
    save_location
    redirect_to :root, notice: 'ログインしてください。' unless current_user
  end

  # def user_authorization
  #   @user = User.find_by(id: params[:user_id])
  #   @user ||= User.find_by(id: params[:id]) if @user.nil?
  #   redirect_to :root unless @user == current_user
  # end
end
