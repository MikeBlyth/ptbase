# == Schema Information
#
# Table name: patients
#
#  id                  :integer          not null, primary key
#  first_name          :string(255)
#  last_name           :string(255)
#  middle_name         :string(255)
#  birth_date          :datetime
#  death_date          :date
#  birth_date_exact    :boolean
#  ident               :string(255)
#  sex                 :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  residence           :string(255)
#  phone               :string(255)
#  caregiver           :string(255)
#  hiv_status          :string(255)
#  maternal_hiv_status :string(255)
#  allergies           :string(255)
#  hemoglobin_type     :string(255)
#  comments            :string(255)
#

require "spec_helper"
require "latest_parameters"

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
      patient.middle_name = 'Artexerxes'
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

  # ToDo: Belongs in Prescriptions?
  describe 'Current drugs' do
    let(:patient) {FactoryGirl.create(:patient)}
    let(:prescription) {FactoryGirl.create(:prescription, :confirmed, patient: patient, date: Date.yesterday)}
    let(:current_item) {FactoryGirl.create(:prescription_item, duration: 100, prescription: prescription)}
    let(:non_current_item) {FactoryGirl.create(:prescription_item, duration: 0, prescription: prescription)}

    it 'includes valid item' do
      current_item
      patient.current_drugs.keys.should eq [current_item.drug]
    end

    it 'does not include item no longer being taken' do
      non_current_item
      patient.current_drugs.should be_empty
    end

    it 'does not include void item' do
      current_item
      prescription.update_attributes(:void => true)
      patient.current_drugs.should be_empty
    end

    it 'does not include unconfirmed item' do
      current_item
      prescription.update_attributes(:confirmed => false)
      patient.current_drugs.should be_empty
    end

  end

  # This drug regimen stuff will be reworked or at least refactored so we don't need separate methods
  # for the different regimens.
  describe 'identifying start and end of drug regimens' do
    let(:patient) {FactoryGirl.create(:patient)}
    let(:some_start_date) {DateTime.now - 1.year}
    let(:some_end_date) {DateTime.now  - 6.months}
    let(:second_start_date) {DateTime.now - 3.months}
    let(:second_end_date) {DateTime.now  - 1.months}

    def define_regimen(patient, type, started, ended=nil, regimen=nil )
      FactoryGirl.create(:visit, patient: patient, date: started, "#{type}_status" => 'B', arv_regimen: regimen)
      FactoryGirl.create(:visit, patient: patient, date: ended, "#{type}_status" => 'X') if ended
    end

    def change_regimen(patient, type, changed, regimen=nil )
      start_rec = FactoryGirl.create(:visit, patient: patient, date: changed, "#{type}_status" => 'V', arv_regimen: regimen)
    end

    describe 'ARV regimen' do

      context 'when patient has never started a regimen' do
        it 'returns nil for start and end' do
          patient.arv_begin.should be_nil
          patient.arv_stop.should be_nil
        end
      end

      context 'when patient is currently on first regimen' do
        it 'returns beginning date, nil end date' do
          define_regimen(patient, 'arv', some_start_date)
          patient.arv_begin.should eq some_start_date
          patient.arv_stop.should be_nil
        end
      end

      context 'when patient has stopped a regimen' do
        it 'returns correct begin and end dates' do
          define_regimen(patient, 'arv', some_start_date, some_end_date)
          patient.arv_begin.should eq some_start_date
          patient.arv_stop.should eq some_end_date
        end
      end

      context 'when patient has restarted a regimen' do
        it 'returns newer start date and nil stop date' do
          define_regimen(patient, 'arv', some_start_date, some_end_date)
          define_regimen(patient, 'arv', second_start_date)
          patient.arv_begin.should eq second_start_date
          patient.arv_stop.should eq nil
        end

      end

      context 'when patient has restarted a regimen and stopped it' do
        it 'returns newer start and stop dates' do
          define_regimen(patient, 'arv', some_start_date, some_end_date)
          define_regimen(patient, 'arv', second_start_date, second_end_date)
          patient.arv_begin.should eq second_start_date
          patient.arv_stop.should eq second_end_date
        end

      end

    end

    describe 'Anti-TB regimen' do

      context 'when patient has never started a regimen' do
        it 'returns correct begin and end dates' do
          patient.anti_tb_begin.should be_nil
          patient.anti_tb_stop.should be_nil
        end
      end

      context 'when patient is currently on first regimen' do
        it 'returns correct begin and end dates' do
          define_regimen(patient, 'anti_tb', some_start_date)
          patient.anti_tb_begin.should eq some_start_date
          patient.anti_tb_stop.should be_nil
        end
      end

      context 'when patient has stopped a regimen' do
        it 'returns correct begin and end dates' do
          define_regimen(patient, 'anti_tb', some_start_date, some_end_date)
          patient.anti_tb_begin.should eq some_start_date
          patient.anti_tb_stop.should eq some_end_date
        end
      end

      context 'when patient has restarted a regimen' do
        it 'returns newer start date and nil stop date' do
          define_regimen(patient, 'anti_tb', some_start_date, some_end_date)
          define_regimen(patient, 'anti_tb', second_start_date)
          patient.anti_tb_begin.should eq second_start_date
          patient.anti_tb_stop.should eq nil
        end

      end

      context 'when patient has restarted a regimen and stopped it' do
        it 'returns newer start date and nil stop date' do
          define_regimen(patient, 'anti_tb', some_start_date, some_end_date)
          define_regimen(patient, 'anti_tb', second_start_date, second_end_date)
          patient.anti_tb_begin.should eq second_start_date
          patient.anti_tb_stop.should eq second_end_date
        end

      end

    end

    describe 'Current ARV regimen began' do

      context 'no visits yet' do
        it 'returns nil' do
          patient.current_arv_regimen_began.should be_nil
        end
      end

      context 'not on a regimen' do
        it 'returns nil' do
          FactoryGirl.create(:visit, patient: patient)
          patient.current_arv_regimen_began.should be_nil
        end
      end

      context 'started a regimen and is continuing it' do
        it 'returns the beginning date' do
          define_regimen(patient, 'arv', some_start_date, nil, 'Regimen 1')
          patient.current_arv_regimen_began.should eq some_start_date
        end
      end

      context 'started a regimen and it was explicitly changed' do

        it 'returns the changed date' do
          define_regimen(patient, 'arv', some_start_date, nil, 'Regimen 1')
          change_regimen(patient, 'arv', second_start_date, 'Regimen 2')
          patient.current_arv_regimen_began.should eq second_start_date
        end
      end

      context 'regimen was changed but not noted (so was implicit)' do
        it 'returns the changed date' do
          define_regimen(patient, 'arv', some_start_date, nil, 'Regimen 1')
          define_regimen(patient, 'arv', second_start_date, nil, 'Regimen Q')
          patient.current_arv_regimen_began.should eq second_start_date
        end
      end

      context 'regimen was left blank in a subsequent visit, then re-established' do
        it 'returns the original date, ignoring empty data' do
          define_regimen(patient, 'arv', some_start_date, nil, 'Regimen 1')
          FactoryGirl.create(:visit, patient: patient, date: second_start_date)
          FactoryGirl.create(:visit, patient: patient, date: second_end_date, arv_regimen: 'Regimen 1')
          patient.current_arv_regimen_began.should eq some_start_date
        end
      end

      context 'regimen was left blank in a many subsequent visits, not re-established' do
        it 'returns the original date, ignoring empty data' do
          define_regimen(patient, 'arv', some_start_date, nil, 'Regimen 1')
          FactoryGirl.create_list(:visit, 5, patient: patient, date: second_start_date)
          patient.current_arv_regimen_began.should be_nil
        end
      end

      context 'regimen was left blank in many subsequent visits, then re-established' do
        it 'returns the latest date without long gap' do
          define_regimen(patient, 'arv', some_start_date, nil, 'Regimen 1')
          FactoryGirl.create_list(:visit, 5, patient: patient, date: some_end_date)
          FactoryGirl.create(:visit, patient: patient, date: second_start_date, arv_regimen: 'Regimen 1')
          FactoryGirl.create(:visit, patient: patient, date: Date.today, arv_regimen: 'Regimen 1')
          patient.current_arv_regimen_began.should eq second_start_date
        end
      end

      context 'regimen was left blank in many subsequent visits but "Continuing" status was noted' do
        it 'returns the original starting date' do
          define_regimen(patient, 'arv', some_start_date, nil, 'Regimen 1')
          FactoryGirl.create_list(:visit, 5, patient: patient, date: some_end_date, arv_status: 'C')
          FactoryGirl.create(:visit, patient: patient, date: second_start_date, arv_regimen: 'Regimen 1')
          FactoryGirl.create(:visit, patient: patient, date: Date.today, arv_regimen: 'Regimen 1')
          patient.current_arv_regimen_began.should eq some_start_date
        end
      end

    end
  end
end
