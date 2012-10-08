# The Campaign class is the model for campaign.
#
# Author:: Al Kivi  -  License:: MIT

class Campaign < Sequel::Model
  # The timestamps plugin is used to automatically fill two database columns
  # with the dates on which an object was created and when it was modified.
  plugin :validation_helpers
  plugin :timestamps, :create => :created_at, :update => :updated_at, :delete => :deleted_at

  many_to_one :user
  one_to_many :lead
  one_to_many :opport
  
  ##
  # This is called whenever an instance of this class is saved or updated. 
  def validate
    validates_presence([:name])
  end
end
