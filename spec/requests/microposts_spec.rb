require 'spec_helper'

describe "Microposts" do

  before(:each) do
    @user = Factory(:user)
    visit signin_path
    fill_in :email,    :with => @user.email
    fill_in :password, :with => @user.password
    click_button
  end

  it "should not create a micropost upon empty content" do
    lambda do
      visit root_path
      fill_in :micropost_content, :with => ""
      click_button
      response.should render_template('pages/home')
      response.should have_selector("div.field_with_errors")
    end.should_not change(Micropost, :count)
  end

  it "should create a micropost with valid content" do
    content = "sample content"
    lambda do
      visit root_path
      fill_in :micropost_content, :with => content
      click_button
      flash[:success].should =~ /successfully saved/i
      response.should have_selector("span.content", :content => content)
    end.should change(Micropost, :count).by(1)
  end
end
