require 'spec_helper'

describe PagesController do

  render_views

  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end

    it "should have the correct title" do
      get 'home'
      response.should have_selector("title:contains('Home')")
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
