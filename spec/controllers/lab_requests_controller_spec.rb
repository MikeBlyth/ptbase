require "spec_helper"

# Given an array of lab service ids [5,6], and the base params, return params with
# the lab services inserted in the way that the is done by the view, e.g.
# params updated to {:lab_request => {...}, :services => {'5' =>'1', '6' =>'6'}} or whatever
def set_selected_services_params(params, selected_service_ids)
  svc_hash = {}
  selected_service_ids.each {|id| svc_hash[id.to_s] = '1'}
  params[:services] = svc_hash
  return params
end

describe LabRequestsController do

  let(:patient) {FactoryGirl.create(:patient)}
  let(:provider) {FactoryGirl.create(:provider)}
  let(:base_params) { {:lab_request => {patient_id: patient.id, provider_id: provider.id}, :services => {}} }
  it 'creates an empty request (no labs ordered)' do
    params = {:lab_request => {patient_id: patient.id, provider_id: provider.id}}
    lambda {post :create, params}.should change(LabRequest, :count).by(1)
    request = LabRequest.last
    request.provider.should eq provider
    request.patient.should eq patient
    request.date.to_date.should eq Date.today
  end

  it 'creates a request with labs ordered' do
    selected = [5,6]
    params = set_selected_services_params(base_params, selected)
    lambda {post :create, params}.should change(LabResult, :count).by(2)
    request = LabRequest.last
    results = request.lab_results
    results.map {|r| r.lab_service_id}.sort.should eq selected
    results.map {|r| r.lab_request_id}.should eq [request.id, request.id]
  end


end
