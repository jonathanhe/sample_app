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
end
