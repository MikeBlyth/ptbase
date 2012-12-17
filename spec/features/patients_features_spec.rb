require 'spec_helper'
include RequestHelpers

feature "Patients" do

  it "allows user to login" do
#    user = create_logged_in_user
    user = User.create(email: 'test@example.com', password: 'passxxx', username: 'SomeUser')
    visit '/users/login'
#save_and_open_page
    fill_in 'user_username', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'Sign in'
  end

  scenario "creating a new patient" do
#    user = FactoryGirl.create(:admin_user, password: 'opensesame')
#    login_as(user, :scope => :user)
    create_logged_in_user
    visit '/patients'
    click_link "Create New"

    fill_in "First name", with: "Antonio"
    fill_in "Last name", with: "Vivaldi"
    fill_in "Ident", with: "V001"
    fill_in "Birth date", with: '21 Nov 2012'
    click_button "Create"
    expect(page).to have_text("Created Antonio Vivaldi [V001]")
    patient = Patient.last
    patient.last_name.should == 'Vivaldi'
    patient.first_name.should == 'Antonio'
    patient.ident.should == 'V001'
    patient.birth_date.to_date.should == Date.new(2012, 11, 21)
  end
end