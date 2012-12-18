require "spec_helper"

describe PatientsController do

  context 'when user is not logged in' do

    it "should redirect to login path" do
      get :index
      response.should redirect_to new_user_session_path
    end
  end

  context 'when user is logged in' do

    it "should redirect to login path" do
      controller_sign_in
      get :index
      response.status.should == 200
    end
  end

  describe 'creates new patient' do

    it 'creates a new patient' do
      controller_sign_in
      patient = FactoryGirl.attributes_for(:patient)
      put :create, :patient => patient
      response.status.should == 302 # Redirects after creating patient
      new_patient= Patient.last
      patient.each {|k,v| new_patient.send(k).should eq v}
    end
  end

end
