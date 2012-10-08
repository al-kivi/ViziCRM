# This module provides some basic methods with the Viziframe application.
#
# Author::    Al Kivi <al.kivi@vizitrax.com>
# License::   MIT
class MainController < BaseController

  def index
    @lwidth = '20%'
    @rwidth = '0'
    @height = '800'
    data = Action.filter.reverse_order(:id).all
    @actions = paginate(data, :limit => 10)
    session[:showmore] = false
    @items = Action.recent_items
  end
  
  def about
    unless logged_in?
      flash[:message] = 'You must login to see the requested page'
      redirect('users/login')
    end
    @lwidth = '0%'
    @rwidth = '20%'
    @height = '800'
  end

  # The string returned at the end of the function is used as the html body
  # if there is no template for the action. if there is a template, the string
  # is silently ignored
  def notemplate
    @title = 'Welcome to ViziCRM!'
    
    return 'There is no template associated with this action.'
  end
  
end
