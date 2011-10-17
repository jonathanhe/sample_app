require 'spec_helper'

describe SessionsController do

  describe "GET 'new'" do
    # it is important to render views here
    render_views

    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Sign in")
    end
  end

end
