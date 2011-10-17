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
      render('new')
    else
      # TODO: we are signed in, should re-direct to users/show page
    end
  end

  def destroy
  end

end
