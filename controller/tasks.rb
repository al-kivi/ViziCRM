# This is the Task class for the CRM application written in Ramaze
#
# Author:: Al Kivi  -  License:: MIT

class Tasks < BaseController
  map '/tasks'

  # These methods require the user to be logged in
  before(:new, :edit, :delete) do
    unless logged_in?
      flash[:error] = 'You must log in to access this function'
      redirect(Tasks.r(:index))
    end
  end

  # Shows an overview of all the items
  def index
    @lwidth = '20%'
    @rwidth = '0'
    @height = '800'
    @name_array = ['a','d','c']
    @item_array = []
    @chk_array = ['','','']
    if request.params.length == 0
      @item_array = ['Assigned', 'Declined', 'Completed']
      @chk_array = ['checked','checked','checked']
    end
    if request.params[@name_array[0]]
      @item_array << 'Assigned'
      @chk_array[0] = 'checked'
    end
    if request.params[@name_array[1]]
      @item_array << 'Declined'
      @chk_array[1] = 'checked'
    end
    if request.params[@name_array[2]]
      @item_array << 'Completed'
      @chk_array[2] = 'checked'
    end
    data = Task.filter(:deleted_at => nil).filter(:status => @item_array)
    @tasks = paginate(data, :limit => 5)
    @items = Action.recent_items
    session[:method] = 'index'
  end

  # Shows a single item
  def view(id)
    @lwidth = '20%'
    @rwidth = '0'
    @height = '800'
    @task = Task[id]
    session[:method] = 'view'

    if @task.nil?
      redirect Tasks.r(:index)
    end
    @items = Action.recent_items
  end

  def showmore(id)
    @task = flash[:form_data] || Task[id]
    if session[:showmore]
      session[:showmore] = false
    else
      session[:showmore] = true
    end
    case session[:method]
    when 'edit'
      redirect '/tasks/edit/'+id.to_s
    when 'view'
      redirect '/tasks/view/'+id.to_s
    else
      redirect '/tasks/new'
    end
  end
  
  # Allows user to create a new item
  def new
    @lwidth = '20%'
    @rwidth = '0'  
    @task  = flash[:form_data] || Task.new
    session[:method] = 'new'
    Action.add_record(@task.id, session[:email], 'created', 'task', @task.name)
    @items = Action.recent_items
  end

  # Allows user to edit an existing item
  def edit(id)
    @lwidth = '20%'
    @rwidth = '0'
    @task = flash[:form_data] || Task[id]
    session[:method] = 'edit'

    # Make sure the item exists
    if @task.nil?
      flash[:error] = 'The specified Task is invalid'
      redirect_referrer
    end
    @name = "Edit #{@task.name}"
    Action.add_record(@task.id, session[:email], 'updated', 'task', @task.name)
    @items = Action.recent_items
  end
  
  # Saves the changes made by edit or new method
  def save
    redirect(Tasks.r(:index)) if request.params['cancel'] == "Cancel"
  
    # Fetch the request data to use for a new or updated object
    data = request.subset(:name, :due_at, :category, :priority, :status,
      :completed_at, :asset_id, :asset_type, :bucket)
    extra = request.subset(:assigned_to, :account_to, :contact_to)
#p data
    data['due_at'] = Time.at(0) if data['due_at'] == "0"  
    data['assigned_id'] = User[:email=>extra['assigned_to']].id
    data['account_id'] = Account[:name=>extra['account_to']].id
    data['contact_id'] = Contact[:full_name=>extra['contact_to']].id
    id = request.params['id']
    data['user_id'] = user.id
    # If an ID is given it's assumed the user wants to edit an existing Task,
    # otherwise a new one will be created.
    if !id.nil? and !id.empty?
      @task = Task[id]

      # Let's make sure the Task is valid
      if @task.nil?
        flash[:error] = 'The specified Task is invalid...'
        redirect_referrer
      end
      success = 'The Task has been updated'
      error   = 'The Task could not be updated'
    # Create a new object
    else
      @task = Task.new
      success = 'The Task has been successfully created'
      error   = 'The Task could not be created'
    end

    # Time to actually insert/update the data
    begin
      # If the object doesn't exist, it will be automatically created
      @task.update(data)
      flash[:success] = success

      # Redirect the user back to the correct page.
      redirect(Tasks.r(:index))   
    rescue => e
      Ramaze::Log.error(e)

      # Store the submitted data and the errors. The errors are used by BlueForm
      flash[:form_data]   = @task
      flash[:form_errors] = @task.errors
      flash[:error]       = error

      redirect_referrer
    end
  end

  # Removes a single item from the database.
  def delete(id)
    @task = flash[:form_data] || Task[id]
    if session[:email] == 'admin'
      begin
        Task.filter(:id => id).destroy
        flash[:success] = 'The specified Task has been removed'
      rescue => e
        Ramaze::Log.error(e.message)
        flash[:error] = 'The specified Task could not be removed'
      end
    else
      @task.save
    end
    Action.add_record(@task.id, session[:email], 'deleted', 'task', @task.name)
    redirect(Tasks.r(:index))
  end
end
