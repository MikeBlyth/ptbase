# == Schema Information
#
# Table name: lab_results
#
#  id             :integer          not null, primary key
#  lab_request_id :integer
#  lab_service_id :integer
#  result         :string(255)
#  date           :datetime
#  status         :string(255)
#  abnormal       :boolean
#  panic          :boolean
#  comments       :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require "spec_helper"

describe LabResult do
  let(:lab_result) {FactoryGirl.build(:lab_result)}

  describe 'validation' do
    it { should validate_presence_of(:lab_service_id)}
  end

  describe 'get_selected_labs_by_date' do

    it 'selects labs for the given patient only' do
      lab_result = FactoryGirl.create_list(:lab_result, 2, result: '50').first
      lab_svc = lab_result.lab_service.abbrev
      patient = lab_result.patient
      selected = LabResult.get_selected_labs_by_date(patient, nil, lab_svc)
      select_first = selected.first
      select_first.lab_service.should eq lab_result.lab_service
      select_first.date.should eq lab_result.date
      select_first.result.should eq 50.0
      selected.count.should eq 1
    end

    it 'converts result to float when possible' do
      lab_result = FactoryGirl.create(:lab_result, result: '50')
      selected = LabResult.get_selected_labs_by_date(lab_result.patient)
      puts LabResult.first.inspect
      puts selected[0].inspect
      selected[0].result.should eq 50.0
    end

    it 'selects labs for the given date range only' do
      patient = FactoryGirl.create(:patient)
      lab_request = FactoryGirl.create(:lab_request, patient: patient)
      lab_svc = FactoryGirl.create(:lab_service, lab_group: nil)
      lab_results = FactoryGirl.create_list(:lab_result, 2, lab_request: lab_request, lab_service: lab_svc)
      lab_results.first.update_attributes(date: Date.today - 1.year)
      selected = LabResult.get_selected_labs_by_date(patient, 30, lab_svc.abbrev)
      selected.first.date.should > Date.today - 31.days
      selected.count.should eq 1
    end

    it 'returns only selected lab types (third param)' do
      patient = FactoryGirl.create(:patient)
      lab_request = FactoryGirl.create(:lab_request, patient: patient)
      lab_results = FactoryGirl.create_list(:lab_result, 2, lab_request: lab_request)
      lab_svc = lab_results.first.lab_service
      selected = LabResult.get_selected_labs_by_date(patient, 30, lab_svc.abbrev)
      selected.first.lab_service.should eq lab_svc
      selected.count.should eq 1
#      puts "Selected labs with abbrev #{lab_svc.abbrev} from #{LabResult.all}, returning #{selected.all}"
    end

    it 'finds by sym or string' do
      patient = FactoryGirl.create(:patient)
      lab_request = FactoryGirl.create(:lab_request, patient: patient)
      lab_results = FactoryGirl.create_list(:lab_result, 2, lab_request: lab_request)
      lab_svc = lab_results.first.lab_service
      selected = LabResult.get_selected_labs_by_date(patient, 30,
                                lab_results[0].lab_service.abbrev.to_s,
                                lab_results[1].lab_service.abbrev.to_sym)
      selected.count.should eq 2
      selected[0].lab_service.should eq lab_results[0].lab_service
      selected[1].lab_service.should  eq lab_results[1].lab_service
    end

    it 'returns all lab types when none specified' do
      patient = FactoryGirl.create(:patient)
      lab_request = FactoryGirl.create(:lab_request, patient: patient)
      lab_results = FactoryGirl.create_list(:lab_result, 2, lab_request: lab_request)
      selected = LabResult.get_selected_labs_by_date(patient, 30)
      selected.count.should eq 2
    end

  end
end

