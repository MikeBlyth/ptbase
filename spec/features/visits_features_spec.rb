require 'spec_helper'
include RequestHelpers

feature "Visits" do

  scenario "creating a new visit" do
#    user = FactoryGirl.create(:admin_user, password: 'opensesame')
#    login_as(user, :scope => :user)
    create_logged_in_user
    patient = FactoryGirl.create(:patient_with_health_data)
    pt_id = patient.id
    path = "/visits/new?patient_id=#{pt_id}&association=visits&parent_scaffold=patients&patient_id=#{pt_id}"
    visit path
    expect(page).to have_text("Create Visit")
    if page.has_selector?("#visit_weight")
      fill_in "visit[weight]", with: 3.0
    else
      puts "NOT FOUND"
    end
    filled_values = fill_all_inputs(Visit, exclude: ['dx2'],
                    warnings: true,
                    head_circ: 70.0 ,
                    next_visit: Date.tomorrow
                    )
    click_button 'Create'
#save_and_open_page
    Visit.last.should_not be_nil
    check_all_equal(Visit.last, filled_values).should be_true
  end
end

