class UsersController < ApplicationController
  def show
    @title = "Your account info"
    @user = User.find(@params[:id])
  end

  def new
    @title = "Sign up"
  end

end
