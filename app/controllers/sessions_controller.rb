class SessionsController < ApplicationController
  def new
    @title = "Sign in"
  end

  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])

    if user.nil?
      flash.now[:error] = "Email or password invalid, please try again."
      @title = "Sign in"
      render 'new'
    else
      sign_in user
      redirect_to user
#      flash.now[:success] = "Welcome back, " . user.name
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
