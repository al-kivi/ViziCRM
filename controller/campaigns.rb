# This is the Campaign class for the CRM application written in Ramaze
#
# Author:: Al Kivi  -  License:: MIT

class Campaigns < BaseController
  map '/campaigns'

  # These methods require the user to be logged in
  before(:new, :edit, :delete) do
    unless logged_in?
      flash[:error] = 'You must log in to access this function'
      redirect(Campaigns.r(:index))
    end
  end
  
  # Shows an overview of all the items
  def index
    @lwidth = '20%'
    @rwidth = '0'
    @height = '800'
    if request.params['value']
      @value = request.params['value']
    else
      @value = nil
    end
    data = Campaign.filter(:public => true, :deleted_at => nil).filter(Sequel.ilike(:name, "%#{@value}%"))
  # p data
    @campaigns = paginate(data, :limit => 5)
    session[:method] = 'index'
    session[:showmore] = false
    @items = Action.recent_items
  end
  
  # Shows a single item
  def view(id)
    @lwidth = '20%'
    @rwidth = '0'
    @height = '800'
    @campaign = Campaign[id]
    session[:method] = 'view'

    if @campaign.nil?
      redirect Campaigns.r(:index)
    end
    @items = Action.recent_items
  end
  
  def showmore(id)
    @campaign = flash[:form_data] || Campaign[id]
    if session[:showmore]
      session[:showmore] = false
    else
      session[:showmore] = true
    end
    case session[:method]
    when 'edit'
      redirect '/campaigns/edit/'+id.to_s
    when 'view'
      redirect '/campaigns/view/'+id.to_s
    else
      redirect '/campaigns/new'
    end
  end
  
  # Allows user to create a new item
  def new
    @lwidth = '20%'
    @rwidth = '0'  
    @campaign  = flash[:form_data] || Campaign.new
    session[:method] = 'new'
    @campaign.public = true
    Action.add_record(@campaign.id, session[:email], 'created', 'campaign', @campaign.name)
    @items = Action.recent_items
  end

  # Allows user to edit an existing item
  def edit(id)
    @lwidth = '20%'
    @rwidth = '0'
    @campaign = flash[:form_data] || Campaign[id]
    session[:method] = 'edit'

    # Make sure the item exists
    if @campaign.nil?
      flash[:error] = 'The specified Campaign is invalid'
      redirect_referrer
    end
    @name = "Edit #{@campaign.name}"
    Action.add_record(@campaign.id, session[:email], 'updated', 'campaign', @campaign.name)
    @items = Action.recent_items
  end
  
  # Saves the changes made by edit or new method
  def save
    redirect(Campaigns.r(:index)) if request.params['cancel'] == "Cancel"
  
    # Fetch the request data to use for a new or updated object
    data = request.subset(:name, :status, :starts_on, :ends_on, 
      :target_leads, :target_revenue, :public)
    if data['public'].nil?
      data['public'] = 0
    else
      data['public'] = 1
    end
    id = request.params['id']
    data['user_id'] = user.id
    # If an ID is given it's assumed the user wants to edit an existing Campaign,
    # otherwise a new one will be created.
    if !id.nil? and !id.empty?
      @campaign = Campaign[id]

      # Let's make sure the Campaign is valid
      if @campaign.nil?
        flash[:error] = 'The specified Campaign is invalid...'
        redirect_referrer
      end
      success = 'The Campaign has been updated'
      error   = 'The Campaign could not be updated'
    # Create a new object
    else
      @campaign = Campaign.new
      success = 'The Campaign has been successfully created'
      error   = 'The Campaign could not be created'
    end

    # Time to actually insert/update the data
    begin
      # If the object doesn't exist, it will be automatically created
      @campaign.update(data)

      flash[:success] = success

      # Redirect the user back to the correct page.
      redirect(Campaigns.r(:index))   
    rescue => e
      Ramaze::Log.error(e)

      # Store the submitted data and the errors. The errors are used by BlueForm
      flash[:form_data]   = @campaign
      flash[:form_errors] = @campaign.errors
      flash[:error]       = error

      redirect_referrer
    end
  end

  # Removes a single item from the database.
  def delete(id)
    # The call uses a begin/rescue block so any errors can be handled properly
    begin
      Campaign.filter(:id => id).destroy
      flash[:success] = 'The specified Campaign has been removed'
    rescue => e
      Ramaze::Log.error(e.message)
      flash[:error] = 'The specified Campaign could not be removed'
    end
    Action.add_record(@campaign.id, session[:email], 'deleted', 'campaign', @campaign.name)
    redirect(Campaigns.r(:index))
  end
  
end
