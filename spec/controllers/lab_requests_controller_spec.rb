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

  describe 'create' do
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

  describe 'edit' do
    before(:each) do
      # Set up an existing lab_request with one lab ordered (@service_1). @service_2 is created
      # but not added yet
      @lab_request = FactoryGirl.create(:lab_request, patient: patient, provider: provider)
      @service_1, @service_2 = FactoryGirl.create_list(:lab_service, 2)
      @lab_request.lab_results << FactoryGirl.create(:lab_result, lab_service: @service_1, lab_request: @lab_request)
      @params = base_params.merge({id: @lab_request.id}) # needed for :update
    end

    it 'pre-check setup' do
      results = @lab_request.lab_results
      LabRequest.all.length.should eq 1
      results.length.should eq 1
      results.first.lab_service.should eq @service_1
    end

    it 'adds labs that are not already requested (pending)' do
      selected = [@service_1.id, @service_2.id]
      params = set_selected_services_params(@params, selected)
      post :update, params
      LabResult.where(:lab_service_id => @service_2.id).should_not be_empty
    end

    it 'deletes pending labs that are not now requested (i.e. were deleted)' do
      selected = [@service_2.id]
      params = set_selected_services_params(@params, selected)
      post :update, params
      @lab_request.lab_results.size.should eq 1
      LabResult.where(:lab_service_id => @service_1.id).should be_empty
    end

    # Just de-selecting a requested lab does not delete it if it is already beyond the
    # 'pending' stage.
    it 'does not delete NON-pending labs that are not now requested (i.e. were deleted)' do
      selected = [@service_2.id]
      @lab_request.lab_results.first.update_attributes(status: 'in progress')
      params = set_selected_services_params(@params, selected)
      post :update, params
      @lab_request.lab_results.size.should eq 2
      LabResult.where(:lab_service_id => @service_1.id).should_not be_empty
    end

    # Add this if we get to the point that the the actual pending need to be kept, rather than
    # simply having the set of lab services being requested. For example, if the user can enter
    # a comment along with selecting a service, that comment would have to be retained. Currently,
    # on :update we simply remove all the services and add the ones selected in the update
    #it 'does not affect pending labs that are still requested' do
    #  selected = [@service_1.id, @service_2.id]
    #  original_result = @lab_request.lab_results.first
    #  params = set_selected_services_params(@params, selected)
    #  post :update, params
    #  LabResult.exists?(original_result).should be_true
    #end
  end
end
