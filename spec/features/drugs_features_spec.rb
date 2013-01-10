require 'spec_helper'
include RequestHelpers

feature "Drugs" do

  it 'lists drugs' do
    create_logged_in_user
    drug = FactoryGirl.create(:drug)
    visit '/drugs'
    page.should have_content('Drug preps')
    page.should have_content(drug.name)
  end

end
