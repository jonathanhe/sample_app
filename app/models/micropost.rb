class Micropost < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user

  default_scope :order => 'microposts.created_at desc'

  validates :user_id, :presence => true
  validates :content, :presence => true,
                      :length => { :maximum => 140 }

  def self.from_users_followed_by(user)
    followed_ids = user.following.map(&:id).join(", ")
    where("user_id IN (#{followed_ids}) or user_id = ?", user)
  end
end
