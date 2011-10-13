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

  # register a callback to ensure that we encrypt the password
  # and save to the DB
  before_save :encrypt_password

  def has_password?(submitted_password)
    # we will need some more code here
  end

  private
    def encrypt_password
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      string # To-do: we will need to come back and fix this!
    end
end
