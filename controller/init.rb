# Define a subclass of Ramaze::Controller holding your defaults for all controllers. Note 
# that these changes can be overwritten in sub controllers by simply calling the method 
# but with a different value.

class BaseController < Ramaze::Controller
  layout :default
  helper :xhtml, :user, :paginate, :formatting, :blue_form
  engine :etanni                # this can be changed to :haml, if required

  def partial(name)
    BaseController.render_partial("#{name}")
  end

end

# Here you can require all your other controllers. Note that if you have multiple
# controllers you might want to do something like the following:
#
#  Dir.glob('controller/*.rb').each do |controller|
#    require(controller)
#  end
#
require __DIR__('main')
require __DIR__('users')
require __DIR__('posts')
require __DIR__('rssfeeds')
# controllers for crm application
require __DIR__('accounts')
require __DIR__('tasks')
require __DIR__('campaigns')
require __DIR__('leads')
require __DIR__('contacts')
require __DIR__('opports')
