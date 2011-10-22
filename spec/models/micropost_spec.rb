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

    it "should reject content long content" do
      @user.microposts.build(:content => "a"*141).should_not be_valid
    end
  end
end
