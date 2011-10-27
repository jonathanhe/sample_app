require 'spec_helper'

describe Micropost do
  before(:each) do
    @user = Factory(:user)
    @attr = { :content => "Sample micropost content" }
  end

  it "should create a micropost given valid attributes" do
    @user.microposts.create!(@attr)
  end

  describe "user association with microposts" do

    before(:each) do
      @micropost = @user.microposts.create!(@attr)
    end

    it "should have a user attribute" do
      @micropost.should respond_to(:user)
    end

    it "should have the right association between users and microposts" do
      @micropost.user_id.should == @user.id
      @micropost.user.should == @user
    end
  end

  describe "validations" do
    before(:each) do
      @attr = { :content => "Sample content" }
    end

    it "should require a user_id" do
      Micropost.new(@attr).should_not be_valid
    end

    it "should require a valid content" do
      @user.microposts.build(:content => " ").should_not be_valid
    end

    it "should reject a long content" do
      @user.microposts.build(:content => "a"*141).should_not be_valid
    end
  end

  describe "from_users_followed_by" do

    before(:each) do
      @user2 = Factory(:user, :email => Factory.next(:email))
      @user3 = Factory(:user, :email => Factory.next(:email))

      @user_post  = @user.microposts.create!(:content => "sample")
      @user2_post = @user2.microposts.create!(:content => "foo")
      @user3_post = @user3.microposts.create!(:content => "bar")

      @user.follow!(@user2)
    end

    it "should have a from_users_followed_by method" do
      Micropost.should respond_to(:from_users_followed_by)
    end

    it "should include posts of the user's own post" do
      Micropost.from_users_followed_by(@user).should include(@user_post)
    end

    it "should include post from the user being followed" do
      Micropost.from_users_followed_by(@user).should include(@user2_post)
    end

    it "should not include posts from the user not being followed" do
      Micropost.from_users_followed_by(@user).should_not include(@user3_post)
    end
  end
end
