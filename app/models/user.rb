class User < ActiveRecord::Base
  # create a virtual attribute for password
  attr_accessor   :password

  # Jonathan: use attr_accessible to prevent from 
  # mass assignment vulnerability
  attr_accessible :name, :email, :password, :password_confirmation

  # validate email address
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  :presence => true,
                    :length => { :maximum => 50 }
  validates :email, :presence => true,
                    :format => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }

  # automatically creates the virtual attribute 'password_confirmation'
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }
end
