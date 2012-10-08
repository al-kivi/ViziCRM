# This is the Lead class for the CRM application written in Ramaze
#
# Author:: Al Kivi  -  License:: MIT

class Leads < BaseController
  map '/leads'

  # These methods require the user to be logged in
  before(:new, :edit, :delete) do
    unless logged_in?
      flash[:error] = 'You must log in to access this function'
      redirect(Leads.r(:index))
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
  #  data = Lead.filter.all #(:public => true)
    data = Lead.filter(:public => true, :deleted_at => nil).filter(Sequel.ilike(:full_name, "%#{@value}%"))
    @leads = paginate(data, :limit => 5)
    @items = Action.recent_items
  end

  # Shows a single item
  def view(id)
    @lwidth = '20%'
    @rwidth = '0'
    @height = '800'
    @lead = Lead[id]
    if @lead.status == 'Converted'
      @status_map = ['Converted','New','Contacted','Rejected']
    else
      @status_map = ['New','Contacted','Rejected']
    end
    session[:method] = 'view'

    if @lead.nil?
      redirect Leads.r(:index)
    end
    @items = Action.recent_items
  end
  
  def showmore(id)
    @lead = flash[:form_data] || Lead[id]
    if session[:showmore]
      session[:showmore] = false
    else
      session[:showmore] = true
    end
    case session[:method]
    when 'edit'
      redirect '/leads/edit/'+id.to_s
    when 'view'
      redirect '/leads/view/'+id.to_s
    else
      redirect '/leads/new'
    end
  end
  
  # Allows user to create a new item
  def new
    @lwidth = '20%'
    @rwidth = '0'  
    @lead  = flash[:form_data] || Lead.new
    session[:method] = 'new'
    @lead.public = true
    @status_map = ['New','Contacted','Rejected']
    Action.add_record(@lead.id, session[:email], 'created', 'lead', @lead.last_name)
    @items = Action.recent_items
  end

  # Allows user to edit an existing item
  def edit(id)
    @lwidth = '20%'
    @rwidth = '0'
    @lead = flash[:form_data] || Lead[id]
    if @lead.status == 'Converted'
      @status_map = ['Converted','New','Contacted','Rejected']
    else
      @status_map = ['New','Contacted','Rejected']
    end
    session[:method] = 'edit'

    # Make sure the item exists
    if @lead.nil?
      flash[:error] = 'The specified Lead is invalid'
      redirect_referrer
    end
    @name = "Edit #{@lead.last_name}"
    Action.add_record(@lead.id, session[:email], 'updated', 'lead', @lead.last_name)
    @items = Action.recent_items
  end
  
  # Converts the current lead
  def convert(id)
    @lead = flash[:form_data] || Lead[id]
    @lead.status = 'Converted'
    @lead.save
    @contact = Contact.new
    @contact.user_id = @lead.user_id
    @contact.lead_id = @lead.id
    @contact.assigned_id = @lead.assigned_id
    @contact.first_name = @lead.first_name
    @contact.last_name = @lead.last_name
    @contact.full_name = @lead.full_name
    @contact.email = @lead.email
    @contact.phone = @lead.phone
    @contact.campaign_id = @lead.campaign_id
    @contact.save
    redirect(Leads.r(:index))
  end

  # Saves the changes made by edit or new method
  def save
    redirect(Leads.r(:index)) if request.params['cancel'] == "Cancel"
  
    # Fetch the request data to use for a new or updated object
    data = request.subset(:first_name, :last_name, :email, :phone, :assigned_id,
      :status, :rating, :source, :public)
    extra = request.subset(:campaign_to, :assigned_to)
  # p data
    data['campaign_id'] = Campaign[:name=>extra['campaign_to']].id if extra['campaign_to'] and Campaign[:name=>extra['campaign_to']]
    data['assigned_id'] = User[:email=>extra['assigned_to']].id if extra['assigned_to']
    if data['public'].nil?
      data['public'] = 0
    else
      data['public'] = 1
    end
    data['full_name'] = data['last_name'] + ", " + data['first_name']
    id = request.params['id']
    data['user_id'] = user.id
    # If an ID is given it's assumed the user wants to edit an existing Lead,
    # otherwise a new one will be created.
    if !id.nil? and !id.empty?
      @lead = Lead[id]

      # Let's make sure the Lead is valid
      if @lead.nil?
        flash[:error] = 'The specified Lead is invalid...'
        redirect_referrer
      end
      success = 'The Lead has been updated'
      error   = 'The Lead could not be updated'
    # Create a new object
    else
      @lead = Lead.new
      success = 'The Lead has been successfully created'
      error   = 'The Lead could not be created'
    end

    # Time to actually insert/update the data
    begin
      # If the object doesn't exist, it will be automatically created
      @lead.update(data)

      flash[:success] = success

      # Redirect the user back to the correct page.
      redirect(Leads.r(:index))   
    rescue => e
      Ramaze::Log.error(e)

      # Store the submitted data and the errors. The errors are used by BlueForm
      flash[:form_data]   = @lead
      flash[:form_errors] = @lead.errors
      flash[:error]       = error

      redirect_referrer
    end
  end

  # Removes a single item from the database.
  def delete(id)
    # The call uses a begin/rescue block so any errors can be handled properly
    begin
      Lead.filter(:id => id).destroy
      flash[:success] = 'The specified Lead has been removed'
    rescue => e
      Ramaze::Log.error(e.message)
      flash[:error] = 'The specified Lead could not be removed'
    end
    Action.add_record(@lead.id, session[:email], 'deleted', 'lead', @lead.last_name)
    redirect(Leads.r(:index))
  end
end
