# This is the Contact class for the CRM application written in Ramaze
#
# Author:: Al Kivi  -  License:: MIT

class Contacts < BaseController
  map '/contacts'

  # These methods require the user to be logged in
  before(:edit, :delete) do
    unless logged_in?
      flash[:error] = 'You must log in to access this function'
      redirect(Contacts.r(:index))
    end
  end
  
  # Shows an overview of all the items
  def index
    @lwidth = '20%'
    @rwidth = '0'
    @height = '800' 
  #  data = Contact.filter.all #(:public => true)
    if request.params['value']
      @value = request.params['value']
    else
      @value = nil
    end
    data = Contact.filter(:public => true, :deleted_at => nil).filter(Sequel.ilike(:full_name, "%#{@value}%"))
    @contacts = paginate(data, :limit => 5)
    @items = Action.recent_items
  end

  # Shows a single item
  def view(id)
    @lwidth = '20%'
    @rwidth = '0'
    @height = '800'
    @contact = Contact[id]
    @tasks = Task.filter(:contact_id => id)
    @task_count = @tasks.count
    session[:method] = 'view'
    if @contact.nil?
      redirect Contacts.r(:index)
    end
#    p @contact
    @campaign_name = Array.new(1,@contact.campaign.name)
    @items = Action.recent_items
  end
  
  def showmore(id)
    @contact = flash[:form_data] || Contact[id]
    if session[:showmore]
      session[:showmore] = false
    else
      session[:showmore] = true
    end
    case session[:method]
    when 'edit'
      redirect '/contacts/edit/'+id.to_s
    when 'view'
      redirect '/contacts/view/'+id.to_s
    else
      redirect '/contacts/new'
    end
  end
  
  # Allows user to create a new item
  def new
    @lwidth = '20%'
    @rwidth = '0'  
    @contact  = flash[:form_data] || Contact.new
    session[:method] = 'new'
    @contact.public = true
    @campaign_name = Campaign.map(:name)
    Action.add_record(@contact.id, session[:email], 'created', 'contact', @contact.last_name)
    @items = Action.recent_items
  end

  # Allows user to edit an existing item
  def edit(id)
    @lwidth = '20%'
    @rwidth = '0'
    @contact = flash[:form_data] || Contact[id]
    @tasks = Task.filter(:contact_id => id)
    @task_count = @tasks.count
    session[:method] = 'edit'
    # Make sure the item exists
    if @contact.nil?
      flash[:error] = 'The specified Contact is invalid'
      redirect_referrer
    end
    @name = "Edit #{@contact.last_name}"
    @campaign_name = Array.new(1,@contact.campaign.name)
    Action.add_record(@contact.id, session[:email], 'updated', 'contact', @contact.last_name)
    @items = Action.recent_items
  end
  
  # Saves the changes made by edit or new method
  def save
    redirect(Contacts.r(:index)) if request.params['cancel'] == "Cancel"
  
    # Fetch the request data to use for a new or updated object
    data = request.subset(:first_name, :last_name, :email, :phone,
      :rating, :source, :public)
    extra = request.subset(:campaign_to, :assigned_to, :account_to)
  # p extra
    data['campaign_id'] = Campaign[:name=>extra['campaign_to']].id
    data['assigned_id'] = User[:email=>extra['assigned_to']].id if extra['assigned_to']
    data['account_id'] = Account[:name=>extra['account_to']].id if extra['account_to']
    if data['public'].nil?
      data['public'] = 0
    else
      data['public'] = 1
    end
    data['full_name'] = data['last_name'] + ", " + data['first_name']
    id = request.params['id']
    data['user_id'] = user.id
   p data
    # If an ID is given it's assumed the user wants to edit an existing Contact,
    # otherwise a new one will be created.
    if !id.nil? and !id.empty?
      @contact = Contact[id]

      # Let's make sure the Contact is valid
      if @contact.nil?
        flash[:error] = 'The specified Contact is invalid...'
        redirect_referrer
      end
      success = 'The Contact has been updated'
      error   = 'The Contact could not be updated'
    # Create a new object
    else
      @contact = Contact.new
      success = 'The Contact has been successfully created'
      error   = 'The Contact could not be created'
    end

    # Time to actually insert/update the data
    begin
      # If the object doesn't exist, it will be automatically created
      @contact.update(data)

      flash[:success] = success

      # Redirect the user back to the correct page.
      redirect(Contacts.r(:index))   
    rescue => e
      Ramaze::Log.error(e)

      # Store the submitted data and the errors. The errors are used by BlueForm
      flash[:form_data]   = @contact
      flash[:form_errors] = @contact.errors
      flash[:error]       = error

      redirect_referrer
    end
  end

  # Removes a single item from the database.
  def delete(id)
    # The call uses a begin/rescue block so any errors can be handled properly
    begin
      Contact.filter(:id => id).destroy
      flash[:success] = 'The specified Contact has been removed'
    rescue => e
      Ramaze::Log.error(e.message)
      flash[:error] = 'The specified Contact could not be removed'
    end
    Action.add_record(@contact.id, session[:email], 'deleted', 'contact', @contact.last_name)
    redirect(Contacts.r(:index))
  end
end
