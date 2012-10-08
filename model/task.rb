# The Task class is the model for task.
#
# Author:: Al Kivi  -  License:: MIT

class Task < Sequel::Model
  # The timestamps plugin is used to automatically fill two database columns
  # with the dates on which an object was created and when it was modified.
  plugin :validation_helpers
  plugin :timestamps, :create => :created_at, :update => :updated_at, :delete => :deleted_at

  many_to_one :user
  many_to_one :account
  many_to_one :contact

  def assigned_to
    if self.assigned_id.nil?
      "-"
    else
      User[self.assigned_id].email
    end
  end
  
  def account_to
    if self.contact_id.nil?
      "-"
    else
      Account[self.contact_id].name
    end
  end
  
  def contact_to
    if self.contact_id.nil?
      "-"
    else
      Contact[self.contact_id].full_name
    end
  end

  ##
  # This is called whenever an instance of this class is saved or updated. 
  def validate
    validates_presence([:name, :category])
  end
end
