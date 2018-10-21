module ApplicationHelper

  def page_title
    title = 'AOJ Reco'
    title = 'AOJ Reco' + ' | ' + @page_title if @page_title
    title
  end

  def show?
    action_name == 'show'
  end
end
