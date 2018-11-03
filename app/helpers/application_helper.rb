module ApplicationHelper

  def page_title
    title = 'AOJ Reco'
    title = 'AOJ Reco' + ' | ' + @page_title if @page_title
    title
  end

  def show?
    action_name == 'show'
  end

  def edit?
    action_name == 'edit'
  end

  def active?(controller_name, action_name)
    return 'active' if params[:controller] == controller_name && params[:action] == action_name
    nil
  end

  def controller_active?(controller_name)
    return 'active' if params[:controller] == controller_name
    nil
  end
end
