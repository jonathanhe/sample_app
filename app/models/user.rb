class User < ActiveRecord::Base
  # Jonathan: use attr_accessible to prevent from 
  # mass assignment vulnerability
  attr_accessible :name, :email

  validates :name,  :presence => true,
                    :length => { :maximum => 50 }
  validates :email, :presence => true
end
