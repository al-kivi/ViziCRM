# The Action class is the model for actions.
#
# Author:: Al Kivi  -  License:: MIT

class Action < Sequel::Model
  # The timestamps plugin is used to automatically fill two database columns
  # with the dates on which an object was created and when it was modified.
  plugin :timestamps, :create => :created_at, :update => :updated_at, :delete => :deleted_at

  many_to_one :user

  def self.recent_items
    distinct.select(:item_id, :modeltype, :itemname).order(:id.desc).limit(5)
  end
  
  # Update the action history record
  def self.add_record(itemid, email, actiontype, modeltype, itemname)
    @action = Action.new
    @action.item_id = itemid
    @action.user_id = User[:email=>email].id
    @action.actiontype = actiontype
    @action.modeltype = modeltype
    @action.itemname = itemname
    @action.save
  end 

end
