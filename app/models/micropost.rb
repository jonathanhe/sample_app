class Micropost < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user

  default_scope :order => 'microposts.created_at desc'

  validates :user_id, :presence => true
  validates :content, :presence => true,
                      :length => { :maximum => 140 }

end
