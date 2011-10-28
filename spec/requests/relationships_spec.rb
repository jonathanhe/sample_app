require 'spec_helper'

describe "Relationships" do

  before(:each) do
    @user = Factory(:user)
    integration_sign_in(@user)
    @user2 = Factory(:user, :email => Factory.next(:email))
  end

  describe "Follow" do
    it "should follow other user" do
      lambda do
        visit user_path(@user2)
        click_button
        #what follows the . is the class name
        response.should have_selector("div.actions")
        response.should have_selector("form.edit_relationship", :method => "post")
        response.should have_selector("input", :value => 'delete')
        response.should have_selector("input", :value => "Unfollow")
      end.should change(Relationship, :count).by(1)
    end
  end

  describe "Unfollow" do

    before(:each) do
      @user.follow!(@user2)
    end

    it "should unfollow other user" do
      lambda do
        visit user_path(@user2)
        click_button
        response.should have_selector("div.actions")
        response.should have_selector("form.new_relationship", :method => "post")
        response.should have_selector("input", :name => 'relationship[followed_id]')
        response.should have_selector("input", :value => "Follow")
      end.should change(Relationship, :count).by(-1)
    end
  end
end
