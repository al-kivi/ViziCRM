# The Lead class is the model for lead.
#
# Author:: Al Kivi  -  License:: MIT

class Lead < Sequel::Model
  # The timestamps plugin is used to automatically fill two database columns
  # with the dates on which an object was created and when it was modified.
  plugin :validation_helpers
  plugin :timestamps, :create => :created_at, :update => :updated_at, :delete => :deleted_at

  many_to_one :user
  
  def assigned_to
    if self.assigned_id.nil?
      "-"
    else
      User[self.assigned_id].email
    end
  end

  def campaign_to
    if self.campaign_id.nil?
      "-"
    else
      Campaign[self.campaign_id].name
    end
  end

  ##
  # This is called whenever an instance of this class is saved or updated. 
  def validate
    validates_presence([:first_name, :last_name])
  end
end
