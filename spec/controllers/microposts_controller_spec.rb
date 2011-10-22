require 'spec_helper'

describe MicropostsController do
  render_views

  describe "access control" do

    it "should deny access to 'create'" do
      post :create
      response.should redirect_to signin_path
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to signin_path
    end
  end

  describe "POST 'create'" do
   
    before(:each) do
      test_sign_in(Factory(:user))
    end

    describe "failure" do
      before(:each) do
        @attr = { :content =>"" }
      end

      it "should not create a micropost" do
        lambda do
          post :create, :micropost => @attr
        end.should_not change(Micropost, :count)
      end

      it "should render the homepage" do
        post :create, :micropost => @attr
        response.should render_template('pages/home')
      end
    end

    describe "success" do
      before(:each) do
        @attr = { :content => "Sample post" }
      end

      it "should create a micropost" do
        lambda do
          post :create, :micropost => @attr
        end.should change(Micropost, :count).by(1)
      end

      it "should redirect user to root_path" do
        post :create, :micropost => @attr
        response.should redirect_to root_path
      end

      it "should have a success flash message" do
        post :create, :micropost => @attr
        flash[:success].should =~ /success/i
      end
    end
  end
end
