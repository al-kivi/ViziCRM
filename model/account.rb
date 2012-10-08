# The Account class is the model for accounts.
#
# Author:: Al Kivi  -  License:: MIT

class Account < Sequel::Model
  # The timestamps plugin is used to automatically fill two database columns
  # with the dates on which an object was created and when it was modified.
  plugin :validation_helpers
  plugin :timestamps, :create => :created_at, :update => :updated_at, :delete => :deleted_at

  many_to_one :user

  def assigned_to
    User[self.assigned_id].email
  end

  ##
  # This is called whenever an instance of this class is saved or updated. 
  def validate
    validates_presence([:name, :phone])
  end
end
