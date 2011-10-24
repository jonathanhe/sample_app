class Relationship < ActiveRecord::Base
  attr_accessible :followed_id

  validates :follower_id, :presence => true
  validates :followed_id, :presence => true
end
