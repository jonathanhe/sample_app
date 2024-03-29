require 'spec_helper'

describe "LayoutLinks" do
  describe "GET /layout_links" do
#    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
#      get layout_links_index_path
#      response.status.should be(200)
#    end

    it "should have a home page at /" do
      get '/'
      response.should have_selector("title:contains('Home')")
    end

    it "should have an About page at /about" do
      get '/about'
      response.should have_selector("title:contains('About')")
    end

    it "should have a contact page at /contact" do
      get '/contact'
      response.should have_selector("title:contains('Contact')")
    end

    it "should have a help page at /help" do
      get '/help'
      response.should have_selector("title:contains('Help')")
    end

    it "should have a sign-up page at '/signup'" do
      get '/signup'
      response.should have_selector("title:contains('Sign up')")
    end

    it "should have the right links on the layout" do
      visit root_path
      click_link "About"
      response.should have_selector("title:contains('About')")
      click_link "Help"
      response.should have_selector("title:contains('Help')")
      click_link "Contact"
      response.should have_selector("title:contains('Contact')")
      click_link "Home"
      response.should have_selector("title:contains('Home')")
      click_link "Sign up now!"
      response.should have_selector("title:contains('Sign up')")
    end
  end

  describe "when not signed in" do
    it "should have a sign in link" do
      visit root_path
      response.should have_selector("a", :href => signin_path,
                                         :content => "Sign in")
    end
  end

  describe "when signed in" do
    before(:each) do
      @user = Factory(:user)
      integration_sign_in(@user)
    end

    it "should have a sign out link" do
      visit root_path
      response.should have_selector("a", :href => signout_path,
                                         :content => "Sign out")
    end

    it "should have a user profile link" do
      visit root_path
      response.should have_selector("a", :href => user_path(@user),
                                         :content => "Profile")
    end
  end
end
