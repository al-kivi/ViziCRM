# The Contact class is the model for contact.
#
# Author:: Al Kivi  -  License:: MIT

class Contact < Sequel::Model
  # The timestamps plugin is used to automatically fill two database columns
  # with the dates on which an object was created and when it was modified.
  plugin :validation_helpers
  plugin :timestamps, :create => :created_at, :update => :updated_at, :delete => :deleted_at

  many_to_one :user
  many_to_one :campaign
  many_to_one :account

  def account_to
    if self.account_id.nil?
      "-"
    else
      Account[self.account_id].name
    end
  end

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
