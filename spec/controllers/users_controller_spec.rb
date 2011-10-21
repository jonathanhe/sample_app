require 'spec_helper'

describe UsersController do
  # Jonathan: It is VERY important to render views here.
  # Otherwise, some tests just won't pass.
  render_views

  describe "GET 'new'" do

    it "should be successful" do
      #get 'new'
      get :new
      response.should be_success
    end

    it "should have the right title" do
      #get 'new'
      #response.should have_selector('title:contains("Sign up")')
      get :new
      response.should have_selector("title", :content => "Sign up")
    end

    it "should have a name field" do
      get :new
      response.should have_selector("input[name='user[name]'][type='text']")
    end

    it "should have an email field" do
      get :new
      response.should have_selector("input[name='user[email]'][type='text']")
    end

    it "should have a password field" do
      get :new
      response.should
        have_selector("input[name='user[password]'][type='password']")
    end

    it "should have a password confirmation field" do
      get :new
      response.should
        have_selector("input[name='user[password_confirmation]'][type='password']")
    end

    it "should have a submit field" do
      get :new
      response.should have_selector("input[name='commit'][type='submit']")
    end
  end

  describe "GET 'show'" do

    # User Factory Girl to simulate an instance of User
    before(:each) do
      @user = Factory(:user)
    end

    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end

    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end

    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end

    it "should include the user's name in h1" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end

    it "should include a gravarta image tag in h1" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "gravatar")
    end
  end

  describe "POST 'create'" do

    describe "failure" do
      before(:each) do
        @attr = { :name => "", :email => "", :password => "",
                  :password_confirmation => "" }
      end

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end
    end

    describe "success" do
      before(:each) do
        @attr = { :name => "Jonathan He", :email => "jhe@aabb.com",
                  :password => "foobar", :password_confirmation => "foobar" }
      end

      it "should craete a valid user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end

      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to/i
      end

      # by default, a user should be signed in once signed up
      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
    end
  end

  describe "GET 'edit'" do

    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector("title", :content => "profile")
    end

    it "should have a link to gravatar to change picture" do
      get :edit, :id => @user
      gravatar_url = "http://gravatar.com/emails"
      response.should have_selector("a", :href => gravatar_url,
                                         :content => "update")
    end
  end

  describe "PUT 'update'" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    describe "failure" do
      before(:each) do
        @attr = { :name => "", :email => "", :password => "",
                  :password_confirmation => "" }
      end

      it "should be redirected to edit page" do
        put :update, :id => @user, :user => @attr
        response.should render_template('edit')
      end

      it "should have the right title" do
        put :update, :id => @user, :user => @attr
        response.should have_selector("title", :content => "Edit my profile")
      end
    end

    describe "success" do
      before(:each) do
        @attr = { :name => "test user",
                  :email => "test@example.com",
                  :password => "foobar",
                  :password_confirmation => "foobar" }
      end

      it "should update the user profile" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.name.should == @attr[:name]
        @user.email.should == @attr[:email]
      end

      it "should redirect to the user show page" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to(user_path(@user))
      end

      it "should have a flash message" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /updated/i
      end
    end
  end

  describe "authenticate of edit/update pages" do

    before(:each) do
      @user = Factory(:user)
    end

    describe "for non-signed in users" do

      it "should deny access to the edit page" do
        get :edit, :id => @user
        response.should redirect_to signin_path
      end

      it "should also deny access to the update page" do
        put :update, :id => @user, :user => {}
        response.should redirect_to signin_path
      end
    end

    describe "for signed in users" do
      before(:each) do
        wrong_user = Factory(:user, :email => "user@example.com")
        test_sign_in(wrong_user)
      end

      it "should require matching user for 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
        flash[:notice] =~ /not allowed/i
      end

      it "should require matching user for 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)
        flash[:notice] =~ /not allowed/i
      end
    end
  end

  describe "GET 'index'" do

    describe "for non-signed-in users" do
      it "should deny access" do
        get :index
        response.should redirect_to signin_path
        flash[:notice].should =~ /sign in/i
      end
    end

    describe "for signed-in users" do
      before(:each) do
        @user = test_sign_in(Factory(:user))
        second_user = Factory(:user, :email => "test@example.com")
        third_user  = Factory(:user, :email => "test@example.org")
        @users = [@user, second_user, third_user]

        30.times do
          @users << Factory(:user, :email => Factory.next(:email))
        end
      end

      it "should be successful" do
        get :index
        response.should be_success
      end

      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "Show all users")
      end

      it "should have an element for each user" do
        get :index
        @users[0..2].each do |user|
          response.should have_selector("li", :content => user.name)
        end
      end

      it "should paginate users" do
        get :index
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/users?page=2",
                                           :content => "2")
        response.should have_selector("a", :href => "/users?page=2",
                                           :content => "Next")
      end
    end
  end

  describe "DELETE 'destroy'" do
    before(:each) do
      @user = Factory(:user)
    end

    describe "for non-signed-in users" do
      it "should require the user to sign in" do
        delete :destroy, :id => @user
        response.should redirect_to signin_path
      end
    end

    describe "for non-admin users, but signed in" do

      it "should not destroy the user" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        @user.should_not be_destroyed
      end
    end

    describe "for admin users, signed in" do
      before(:each) do
        admin = Factory(:user, :email => 'admin@aabb.com', :admin => true)
        test_sign_in(admin)
      end

      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end

      it "should redirect to the users page"
    end
  end
end
