require 'spec_helper'
include RequestHelpers

feature "Drug Preps" do

  it 'lists drug preps' do
    create_logged_in_user
    drug_prep = FactoryGirl.create(:drug_prep)
    visit '/drug_preps'
    page.should have_content('Drug Preparations')
    page.should have_content(drug_prep.drug.name)
  end

end
