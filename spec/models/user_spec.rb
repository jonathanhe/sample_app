require 'spec_helper'

describe User do
  before(:each) do
    @attr = { 
      :name => "Example user",
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "should require an email" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "should accept valid email address" do
    addresses = %w[user@example.com THE_USER@foo.bar.org first.last@bar.cn]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email address" do
    addresses = %w[user@example,com user_at_foo.org example.user@bar]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    # Add a user with given email into the database for real
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject email addressed identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe "password validations" do
    it "should require a password and confirmation" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end

    it "should reject short password" do
      User.new(@attr.merge(:password => "fooba", :password_confirmation => "fooba")).
        should_not be_valid
    end

    it "should reject password longer than 40 chars" do
      long_passwd = "a" * 41
      User.new(@attr.merge(:password => long_passwd, :password_confirmation => long_passwd)).
        should_not be_valid
    end
  end

  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    describe "has_password? method" do

      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end

      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end
    end

    describe "authentication method" do

      it "should return nill on email/password mismatch" do
        User.authenticate(@attr[:email], "wrong-password").should be_nil
      end

      it "should return nil for an email not registered in our DB" do
        User.authenticate("non-existed@email", @attr[:password]).should be_nil
      end

      it "should return the valid user on email/password match" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end
    end
  end

  describe "admin attribute" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end

    it "should not be an admin by default" do
      @user.should_not be_admin
    end

    it "should be able to be converted to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end

  describe "association with microposts" do

    before(:each) do
      @user = User.create!(@attr)
      @older_post = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
      @newer_post = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
    end

    it "should respond to micropost" do
      @user.should respond_to(:microposts)
    end

    it "should return micropost in the right order (reverse by time)" do
      @user.microposts.should == [@newer_post, @older_post]
    end

    it "should destroy all posts by the user when the user is deleted" do
      @user.destroy
      [@older_post, @newer_post].each do |p|
        Micropost.find_by_id(p.id).should be_nil
      end
    end

    describe "status feed" do

      it "should have a feed" do
        @user.should respond_to(:feed)
      end

      it "should include all of the current user's posts" do
        @user.feed.include?(@older_post).should be_true
        @user.feed.include?(@newer_post).should be_true
      end

      it "should not include other people's posts" do
        other_user = Factory(:user, :email => Factory.next(:email))
        mp3 = Factory(:micropost, :user => other_user)
        @user.feed.include?(mp3).should be_false
      end
    end
  end

  describe "relationships" do

    before(:each) do
      @user = User.create!(@attr)
      @followed = Factory(:user)
    end

    it "should have a relationships method" do
      @user.should respond_to(:relationships)
    end

    it "should have a following method" do
      @user.should respond_to(:following)
    end

    it "should have a following? method" do
      @user.should respond_to(:following?)
    end

    it "should have a follow! method" do
      @user.should respond_to(:follow!)
    end

    it "should follow a user" do
      @user.follow!(@followed)
      @user.should be_following(@followed)
    end

    it "should include the followed user in the following array" do
      @user.follow!(@followed)
      @user.following.should include(@followed)
    end

    it "should not follow herself" do
      @user.follow!(@user).should be_nil
    end

    it "should have an unfollow! method" do
      @user.should respond_to(:unfollow!)
    end

    it "should be able to unfollow a user" do
      @user.follow!(@followed)
      @user.unfollow!(@followed)
      @user.should_not be_following(@followed)
    end

    it "should have a reverse_relationships method" do
      @user.should respond_to(:reverse_relationships)
    end

    it "should have a followers method" do
      @user.should respond_to(:followers)
    end

    it "should include the follower in the followers array" do
      @user.follow!(@followed)
      @followed.followers.should include(@user)
    end

    it "should destroy all relationships when user is deleted" do
      @user.follow!(@followed)
      @user.destroy
      Relationship.find_by_followed_id(@followed).should be_nil
      Relationship.find_by_follower_id(@user).should be_nil
    end
  end
end
