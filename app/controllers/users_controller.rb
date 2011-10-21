class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy

  def show
    @user = User.find(params[:id])
    @title = "Welcome back " + @user.name + ", your account info"
  end

  def new
    @user = User.new
    @title = "Sign up"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to aabb!"
      # redirect to user profile page if successfully created a user
      redirect_to @user
    else
      # Jonathan: not sure why the flash couldn't be styled properly.
      #flash[:failure] = "Failed to create a new user!"
      # In case of failure, re-direct user back to the sign up screen
      @title = "Sign up"
      render 'new'
    end
  end

  def edit
    # Since we've load the user from correct_user validation, we don't
    # need to load it from the DB again.
    #@user = User.find(params[:id])
    @title = "Edit my profile"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      # successful, redirect to the user profile page
      flash[:success] = "Successfully updated your account settings"
      redirect_to @user
    else
      # other, display error message and redirect to edit page
      @title = "Edit my profile"
      render 'edit'
    end
  end

  def index
    @title = "Show all users"
    @users = User.paginate(:page => params[:page])
  end

  def destroy
    user = User.find(params[:id]).destroy
    flash[:success] = "User " + user.name + " (" + user.email + ") was deleted!"
    redirect_to(users_path)
  end

  private

    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      deny_and_redirect_to_root unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
