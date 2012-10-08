# The Opport class is the model for opport.
#
# Author:: Al Kivi  -  License:: MIT

class Opport < Sequel::Model
  # The timestamps plugin is used to automatically fill two database columns
  # with the dates on which an object was created and when it was modified.
  plugin :validation_helpers
  plugin :timestamps, :create => :created_at, :update => :updated_at, :delete => :deleted_at

  many_to_one :user
  many_to_one :account
  
  def self.sum_revenue_by_campaign(id)
    if self.filter(:campaign_id => id).count > 0
      self.filter(:campaign_id => id).sum(:amount)
    else
      0
    end
  end

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

  ##
  # This is called whenever an instance of this class is saved or updated. 
  def validate
    validates_presence([:name, :stage])
  end
end
