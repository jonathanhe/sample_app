class PagesController < ApplicationController
  def home
    @title = "Home"
    # It is important to create Micropost object here
    # since we are going to show the users' microposts
    # on the home page.
    if signed_in?
      @micropost = Micropost.new
      @feed_items = current_user.feed.paginate(:page => params[:page])
    end
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
