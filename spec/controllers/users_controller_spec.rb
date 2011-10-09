require 'spec_helper'

describe UsersController do
  # Jonathan: It is VERY important to render views here.
  # Otherwise, some tests just won't pass.
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "should have the right title" do
      get 'new'
      response.should have_selector('title:contains("Sign up")')
    end
  end

end
