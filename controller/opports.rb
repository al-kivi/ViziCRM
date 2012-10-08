# This is the Opport class for the CRM application written in Ramaze
#
# Author:: Al Kivi  -  License:: MIT

class Opports < BaseController
  map '/opports'

  # These methods require the user to be logged in
  before(:new, :edit, :delete) do
    unless logged_in?
      flash[:error] = 'You must log in to access this function'
      redirect(Opports.r(:index))
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
    data = Opport.filter(:public => true, :deleted_at => nil).filter(Sequel.ilike(:name, "%#{@value}%"))
    @opports = paginate(data, :limit => 5)
    @items = Action.recent_items
  end

  # Shows a single item
  def view(id)
    @lwidth = '20%'
    @rwidth = '0'
    @height = '800'
    @opport = Opport[id]
    session[:method] = 'view'

    if @opport.nil?
      redirect Opports.r(:index)
    end
    @items = Action.recent_items
  end
  
  def showmore(id)
    @opport = flash[:form_data] || Opport[id]
    if session[:showmore]
      session[:showmore] = false
    else
      session[:showmore] = true
    end
    case session[:method]
    when 'edit'
      redirect '/opports/edit/'+id.to_s
    when 'view'
      redirect '/opports/view/'+id.to_s
    else
      redirect '/opports/new'
    end
  end
  
  # Allows user to create a new item
  def new
    @lwidth = '20%'
    @rwidth = '0'  
    @opport  = flash[:form_data] || Opport.new
    session[:method] = 'new'
    @opport.public = true
    Action.add_record(@opport.id, session[:email], 'created', 'opport', @opport.name)
    @items = Action.recent_items
  end

  # Allows user to edit an existing item
  def edit(id)
    @lwidth = '20%'
    @rwidth = '0'
    @opport = flash[:form_data] || Opport[id]
    session[:method] = 'edit'

    # Make sure the item exists
    if @opport.nil?
      flash[:error] = 'The specified Opport is invalid'
      redirect_referrer
    end
    @name = "Edit #{@opport.name}"
    Action.add_record(@opport.id, session[:email], 'updated', 'opport', @opport.name)
    @items = Action.recent_items
  end
  
  # Saves the changes made by edit or new method
  def save
    redirect(Opports.r(:index)) if request.params['cancel'] == "Cancel"
  
    # Fetch the request data to use for a new or updated object
    data = request.subset(:name, :stage, :closes_on, :probability,
      :amount, :discount)
    extra = request.subset(:assigned_to, :account_to)
    data['assigned_id'] = User[:email=>extra['assigned_to']].id
    data['account_id'] = Account[:name=>extra['account_to']].id if extra['account_to']
    data['closes_on'] = Time.at(0) if data['closes_on'] == "0"
    data['amount'] = data['amount'].gsub!(",","")
    id = request.params['id']
    data['user_id'] = user.id
    # If an ID is given it's assumed the user wants to edit an existing Opport,
    # otherwise a new one will be created.
    if !id.nil? and !id.empty?
      @opport = Opport[id]

      # Let's make sure the Opport is valid
      if @opport.nil?
        flash[:error] = 'The specified Opport is invalid...'
        redirect_referrer
      end
      success = 'The Opportunity has been updated'
      error   = 'The Opportunity could not be updated'
    # Create a new object
    else
      @opport = Opport.new
      success = 'The Opportunity has been successfully created'
      error   = 'The Opportunity could not be created'
    end

    # Time to actually insert/update the data
    begin
      # If the object doesn't exist, it will be automatically created
      @opport.update(data)

      flash[:success] = success

      # Redirect the user back to the correct page.
      redirect(Opports.r(:index))   
    rescue => e
      Ramaze::Log.error(e)

      # Store the submitted data and the errors. The errors are used by BlueForm
      flash[:form_data]   = @opport
      flash[:form_errors] = @opport.errors
      flash[:error]       = error

      redirect_referrer
    end
  end

  # Removes a single item from the database.
  def delete(id)
    # The call uses a begin/rescue block so any errors can be handled properly
    begin
      Opport.filter(:id => id).destroy
      flash[:success] = 'The specified Opportunity has been removed'
    rescue => e
      Ramaze::Log.error(e.message)
      flash[:error] = 'The specified Opportunity could not be removed'
    end
    Action.add_record(@opport.id, session[:email], 'deleted', 'opport', @opport.name)
    redirect(Opports.r(:index))
  end
end
