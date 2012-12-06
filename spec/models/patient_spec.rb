# == Schema Information
#
# Table name: patients
#
#  id               :integer          not null, primary key
#  first_name       :string(255)
#  last_name        :string(255)
#  other_names      :string(255)
#  birth_date       :date
#  death_date       :date
#  birth_date_exact :boolean
#  ident            :string(255)
#  sex              :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require "spec_helper"

describe Patient do

  describe "Validates record" do
    let(:patient) {FactoryGirl.build(:patient)}

    it "with all required data is valid" do
      patient.should be_valid
    end

    it { should validate_presence_of(:last_name)}

    it { should validate_presence_of(:ident)}

    it { should validate_uniqueness_of(:ident)}

    it { should validate_presence_of(:birth_date)}

    it 'marks future birth date invalid' do
      patient.birth_date = Date.tomorrow.to_datetime
      patient.should_not be_valid
      patient.errors[:birth_date].should include "cannot be in the future"
    end
  end

  describe 'compose name' do
    let(:patient){Patient.new(last_name: 'Jones', first_name: 'Bernard', ident: 'XYZ')}

    it 'uses first and last name' do
      patient.name.should eq 'Bernard Jones'
    end

    it 'uses first and last name with middle initial' do
      patient.other_names = 'Artexerxes'
      patient.name.should eq 'Bernard A. Jones'
    end

    it 'name_id gives name + ident' do
      name_id = patient.name_id
      name_id.should match /Jones/
      name_id.should match Regexp.new(patient.ident)
    end

    it 'name_last_first works' do
      patient.name_last_first.should eq 'Jones, Bernard'
    end

    it 'name_last_first_id gives name + ident' do
      name_id = patient.name_last_first_id
      name_id.should match /Jones, Bernard/
      name_id.should match Regexp.new(patient.ident)
    end



  end

end
