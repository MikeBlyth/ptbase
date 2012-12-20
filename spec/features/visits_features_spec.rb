require 'spec_helper'
include RequestHelpers

feature "Visits" do

  scenario "creating a new visit" do
    create_logged_in_user
    patient = FactoryGirl.create(:patient_with_health_data)
    pt_id = patient.id
    # This path lets us go directly to new visit form, accomodating AS
    path = "/visits/new?patient_id=#{pt_id}&association=visits&parent_scaffold=patients&patient_id=#{pt_id}"
    visit path
    expect(page).to have_text("Create Visit")
    page.should have_content("Current medical info")   # Form includes current medical info and
    page.should have_content("Problem list")           # problem list
    filled_values = fill_all_inputs(Visit, exclude: ['dx2'],
                    warnings: true,
                    head_circ: 70.0 ,
                    next_visit: Date.tomorrow
                    )
    click_button 'Create'
    Visit.last.should_not be_nil
    check_all_equal(Visit.last, filled_values).should be_true
  end
end

