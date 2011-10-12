class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @title = "Welcome back " + @user.name + ", your account info"
  end

  def new
    @title = "Sign up"
  end

end
