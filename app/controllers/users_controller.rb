class UsersController < ApplicationController
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
      flash[:success] = "Welcome to aabb!"
      # redirect to user profile page if successfully created a user
      redirect_to @user
    else
      # In case of failure, re-direct user back to the sign up screen
      @title = "Sign up"
      render 'new'
    end
  end
end
