# This is the Account class for the CRM application written in Ramaze
#
# Author:: Al Kivi  -  License:: MIT

class Accounts < BaseController
  map '/accounts'

  # These methods require the user to be logged in
  before(:new, :edit, :delete) do
    unless logged_in?
      flash[:error] = 'You must log in to access this function'
      redirect(Accounts.r(:index))
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
    data = Account.filter(:public => true, :deleted_at => nil).filter(Sequel.ilike(:name, "%#{@value}%"))
    @accounts = paginate(data, :limit => 5)
    @items = Action.recent_items
    session[:method] = 'index'
  end

  # Shows a single item
  def view(id)
    @lwidth = '20%'
    @rwidth = '0'
    @height = '800'
    @account = Account[id]
    @tasks = Task.filter(:account_id => id)
    @opports = Opport.filter(:account_id => id)
    @contacts = Contact.filter(:account_id => id)
    session[:method] = 'view'

    if @account.nil?
      redirect Accounts.r(:index)
    end
    @items = Action.recent_items
  end
  
  def showmore(id)
    @account = flash[:form_data] || Account[id]
    if session[:showmore]
      session[:showmore] = false
    else
      session[:showmore] = true
    end
    case session[:method]
    when 'edit'
      redirect '/accounts/edit/'+id.to_s
    when 'view'
      redirect '/accounts/view/'+id.to_s
    else
      redirect '/accounts/new'
    end
  end
  
  # Allows user to create a new item
  def new
    @lwidth = '20%'
    @rwidth = '0'  
    @account  = flash[:form_data] || Account.new
    session[:method] = 'new'
    @category_list = ["Customer","Partner","Reseller","Competitor"]
    @account.public = true
    Action.add_record(@account.id, session[:email], 'created', 'account', @account.name)
    @items = Action.recent_items
  end

  # Allows user to edit an existing item
  def edit(id)
    @lwidth = '20%'
    @rwidth = '0'
    @account = flash[:form_data] || Account[id]
    @tasks = Task.filter(:account_id => id)
    @opports = Opport.filter(:account_id => id)
    session[:method] = 'edit'

    # Make sure the item exists
    if @account.nil?
      flash[:error] = 'The specified Account is invalid'
      redirect_referrer
    end
    @name = "Edit #{@account.name}"
    Action.add_record(@account.id, session[:email], 'updated', 'account', @account.name)
    @items = Action.recent_items
  end
  
  # Saves the changes made by edit or new method
  def save
    redirect(Accounts.r(:index)) if request.params['cancel'] == "Cancel"
  
    # Fetch the request data to use for a new or updated object
    data = request.subset(:website, :email, :phone, :name, :rating, :category, :public)
    if data['public'].nil?
      data['public'] = 0
    else
      data['public'] = 1
    end
    id = request.params['id']
    data['user_id'] = user.id
    # If an ID is given it's assumed the user wants to edit an existing Account,
    # otherwise a new one will be created.
    if !id.nil? and !id.empty?
      @account = Account[id]

      # Let's make sure the Account is valid
      if @account.nil?
        flash[:error] = 'The specified Account is invalid...'
        redirect_referrer
      end
      success = 'The Account has been updated'
      error   = 'The Account could not be updated'
    # Create a new object
    else
      @account = Account.new
      success = 'The Account has been successfully created'
      error   = 'The Account could not be created'
    end

    # Time to actually insert/update the data
    begin
      # If the object doesn't exist, it will be automatically created
      @account.update(data)

      flash[:success] = success

      # Redirect the user back to the correct page.
      redirect(Accounts.r(:index))   
    rescue => e
      Ramaze::Log.error(e)

      # Store the submitted data and the errors. The errors are used by BlueForm
      flash[:form_data]   = @account
      flash[:form_errors] = @account.errors
      flash[:error]       = error

      redirect_referrer
    end
  end

  # Removes a single item from the database.
  def delete(id)
    # The call uses a begin/rescue block so any errors can be handled properly
    begin
      Account.filter(:id => id).destroy
      flash[:success] = 'The specified Account has been removed'
    rescue => e
      Ramaze::Log.error(e.message)
      flash[:error] = 'The specified Account could not be removed'
    end
    Action.add_record(@account.id, session[:email], 'deleted', 'account', @account.name)
    redirect(Accounts.r(:index))
  end
end
