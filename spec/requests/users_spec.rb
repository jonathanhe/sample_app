require 'spec_helper'

describe "Users" do
  describe "Signup" do
    describe "failure" do
      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",         :with => ""
          fill_in "Email",        :with => ""
          fill_in "Password",     :with => ""
          fill_in "Confirmation", :with => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
    end

    describe "success" do
      it "should create a new user" do
        lambda do
          visit signup_path
          # Note: I use the id rather than label name to fill in test data.
          fill_in :user_name,                  :with => "Jonathan He"
          fill_in :user_email,                 :with => "jon@example.com"
          fill_in :user_password,              :with => "foobar"
          fill_in :user_password_confirmation, :with => "foobar"
          click_button
          response.should have_selector("div.flash.success",
                                       :content => "Welcome")
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end
    end
  end

  # Integration tests for Sign in and Sign out
  describe "sign in and out" do

    describe "failure" do

      it "should not sign a user in" do
        visit signin_path
        fill_in :email,    :with => ""
        fill_in :password, :with => "invalid"
        click_button
        response.should have_selector("div.flash.error", :content => "invalid")
      end
    end

    describe "success" do
      it "should sign a use in" do
        user = Factory(:user)
        integration_sign_in(user)
        controller.should be_signed_in
        click_link "Sign out"
        controller.should_not be_signed_in
      end
    end
  end
end
