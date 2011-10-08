require 'spec_helper'

describe "LayoutLinks" do
  describe "GET /layout_links" do
#    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
#      get layout_links_index_path
#      response.status.should be(200)
#    end

    it "should have a home page at /" do
      get '/'
      response.should have_selector("title:contains('Home')")
    end

    it "should have an About page at /about" do
      get '/about'
      response.should have_selector("title:contains('About')")
    end

    it "should have a contact page at /contact" do
      get '/contact'
      response.should have_selector("title:contains('Contact')")
    end
  end
end
