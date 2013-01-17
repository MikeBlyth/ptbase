require 'spec_helper'
include RequestHelpers

feature "Prescriptions" do

  scenario "creating a new prescription" do
    create_logged_in_user
    patient = FactoryGirl.create(:patient)
    pt_id = patient.id
    provider = FactoryGirl.create(:provider)
    path = "/prescriptions/new?patient_id=#{pt_id}"
    visit path
#save_and_open_page
    expect(page).to have_text("Create new prescription")
    filled_values = fill_all_inputs(Prescription,
                                    warnings: true,
                                    exclude: [:filled],
    )
#puts "Filled values = #{filled_values}"
    select(provider.name)
    item_params = {drug: 'DrugX', interval: 6, duration: 5}
    within('#prescription-items fieldset:first-child') do
      fill_in 'Drug', with: item_params[:drug]
      fill_in 'Interval', with: item_params[:interval]
      fill_in 'Duration', with: item_params[:duration]
    end
    click_button 'Create'
#save_and_open_page
    new_rec = Prescription.last
    new_rec.should_not be_nil
    check_all_equal(new_rec, filled_values).should be_true
    items = new_rec.items
    items.count.should eq 1
    check_all_equal(items.first, item_params).should be_true
  end

  scenario "edit a prescription" do
    create_logged_in_user
    patient = FactoryGirl.create(:patient)
    pt_id = patient.id
    rx = FactoryGirl.create :prescription_with_item, height: nil, weight: nil, date: Date.yesterday
    provider = FactoryGirl.create(:provider, first_name: 'Jimmy')
    puts "path=#{edit_prescription_path(rx)}"
    visit edit_prescription_path(rx)
#save_and_open_page
    expect(page).to have_text("Edit prescription")
    filled_values = fill_all_inputs(Prescription,
                                    warnings: true,
                                    exclude: [:filled],
    )

    select(provider.name)
#puts "Filled values = #{filled_values}"
    item_params = {drug: 'DrugX', dose: 'as needed', interval: 6, duration: 5, unit: 'cap',
            route: 'sub-lingual'}
    within('#prescription-items fieldset:first-child') do
      fill_in 'Drug', with: item_params[:drug]
      fill_in 'Dose', with: item_params[:dose]
      fill_in 'Route', with: item_params[:route]
      fill_in 'Interval', with: item_params[:interval]
      fill_in 'Duration', with: item_params[:duration]
      fill_in 'Unit', with: item_params[:unit]
    end
    click_button 'Update'
#save_and_open_page
    rx.reload
    check_all_equal(rx, filled_values).should be_true
    items = rx.items
    items.count.should eq 1
    check_all_equal(items.first, item_params).should be_true
  end

end

