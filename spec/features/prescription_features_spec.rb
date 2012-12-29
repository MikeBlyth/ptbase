require 'spec_helper'
include RequestHelpers

feature "Prescriptions" do

  scenario "creating a new prescription" do
    create_logged_in_user
    patient = FactoryGirl.create(:patient_with_health_data)
    pt_id = patient.id
    provider = FactoryGirl.create(:provider)
    # This path lets us go directly to new admission form, accomodating AS
    path = "/prescriptions/new?patient_id=#{pt_id}&association=prescriptions&parent_scaffold=patients&patient_id=#{pt_id}"
    visit path
#save_and_open_page
    expect(page).to have_text("Create Prescription")
    filled_values = fill_all_inputs(Prescription,
                                    warnings: true,
                                    exclude: [:filled],
    )
    select(provider.name)
    click_button 'Create'
#save_and_open_page
    new_rec = Prescription.last
    new_rec.should_not be_nil
    check_all_equal(new_rec, filled_values).should be_true
  end
end

