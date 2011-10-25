require 'spec_helper'

describe PagesController do
  # Jonathan: It is VERY important to render views here.
  # Otherwise, some tests just won't pass.
  render_views

  before(:each) do
    @base_title = "aabb"
  end

  describe "GET 'home'" do

    describe "when not signed in" do

      it "should be successful" do
        get 'home'
        response.should be_success
      end

      it "should have the correct title" do
        get 'home'
        response.should have_selector("title", :content => "#{@base_title} | Home")
      end
    end

    describe "when signed in" do
      before(:each) do
        @user = test_sign_in(Factory(:user))
        @user2 = Factory(:user, :email => Factory.next(:email))
        @user2.follow!(@user)
      end

      it "should have right following / followers number" do
        get :home
        response.should have_selector("a", :href => following_user_path(@user),
                                           :content => "0 following")
        response.should have_selector("a", :href => followers_user_path(@user),
                                           :content => "1 follower")
      end
    end
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end
  end

  # The 'About Us' page
  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end
  end

end
