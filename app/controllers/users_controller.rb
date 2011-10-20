class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update]

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
    @user = User.find(params[:id])
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

  private
    def authenticate
      deny_access unless signed_in?
    end
end
