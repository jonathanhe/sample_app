class User < ActiveRecord::Base
  # Jonathan: use attr_accessible to prevent from 
  # mass assignment vulnerability
  attr_accessible :name, :email

  # validate email address
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  :presence => true,
                    :length => { :maximum => 50 }
  validates :email, :presence => true,
                    :format => { :with => email_regex }
end
