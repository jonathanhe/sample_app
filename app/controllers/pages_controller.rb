class PagesController < ApplicationController
  def home
    @title = "Home"
    # It is important to create Micropost object here
    # since we are going to show the users' microposts
    # on the home page.
    @micropost = Micropost.new if signed_in?
  end

  def contact
    @title = "Contact us"
  end

  def about
    @title = "About us"
  end

  def help
    @title = "Help"
  end

end
