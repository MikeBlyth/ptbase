require 'spec_helper'
include RequestHelpers

feature "Admissions" do

  scenario "creating a new admission" do
    create_logged_in_user
    patient = FactoryGirl.create(:patient)
    pt_id = patient.id
    # This path lets us go directly to new admission form, accomodating AS
    path = "/admissions/new?patient_id=#{pt_id}&association=admissions&parent_scaffold=patients&patient_id=#{pt_id}"
    visit path
#save_and_open_page
    expect(page).to have_text("New Admission")
    filled_values = fill_all_inputs(Admission,
                                    warnings: true,
                                    exclude: [:discharge_status],
    )
    select('improved')
    click_button 'Create'
    new_rec = Admission.last
    new_rec.should_not be_nil
    check_all_equal(Admission.last, filled_values).should be_true
    new_rec.discharge_status.should eq 'improved'
  end
end

