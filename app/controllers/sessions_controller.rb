class SessionsController < ApplicationController
  def new
    @title = "Sign in"
  end

  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])

    if user.nil
      # TODO: create an error message and re-render the signin form
    else
      # TODO: we are signed in, should re-direct to users/show page
    end
  end

  def destroy
  end

end
