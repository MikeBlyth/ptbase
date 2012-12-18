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
    fill_all_inputs(Visit, exclude: ['dx2'], warnings: true)
    fill_in "visit[dx]", with: "Other Dxs"
  end
end

