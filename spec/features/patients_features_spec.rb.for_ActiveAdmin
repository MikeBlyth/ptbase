require 'spec_helper'
include RequestHelpers

feature "Patients" do
  let(:authed_user) { create_logged_in_user }

  it "should allow access" do
    visit admin_dashboard_path(authed_user)
    save_and_open_page
    # should be good!
  end

  it "allows user via capybara login" do
#    user = create_logged_in_user
    user = AdminUser.create(email: 'test@example.com', password: 'opensesame')
    visit '/admin/login'
    fill_in 'admin_user_email', with: user.email
    fill_in 'admin_user_password', with: user.password
    click_button 'Login'
    save_and_open_page
  end

  scenario "creating a new patient" do
#    user = FactoryGirl.create(:admin_user, password: 'opensesame')
#    login_as(user, :scope => :user)
    visit '/admin/dashboard'
    click_link "Patients"
    click_link "New Patient"

    fill_in "patient_first_name", with: "first"
    fill_in "patient_last_name", with: "LastName"
    fill_in "patient_ident", with: "ident"
    click_button "Create Patient"

    expect(page).to have_text("successfully created.")
  end
end