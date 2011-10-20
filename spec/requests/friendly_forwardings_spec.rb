require 'spec_helper'

describe "FriendlyForwardings" do

  it "should forward to the requested page after signed in" do
    user = Factory(:user)
    visit edit_user_path(user)
    # We should be redirected to the sign in page since we haven't signed in
    fill_in :email,    :with => user.email
    fill_in :password, :with => user.password
    click_button
    # after signed in, we should be redirected to the original page user
    # try to access (in this case, edit_user_path)
    response.should render_template('users/edit')
  end
end
