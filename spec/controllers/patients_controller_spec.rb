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
      response.status.should == 200 # Goes to show page for the patient
      new_patient= Patient.last
      patient.each {|k,v| new_patient.send(k).should eq v}
    end
  end

  describe 'updates patient' do
    let(:patient) { FactoryGirl.create(:patient, birth_date: DateTime.new(2010,6,15,16,30,0))}
    before(:each) do
      controller_sign_in
    end

    it 'updates a new patient' do
      patient.allergies = 'none'
      put :update, {:patient => {allergies: 'none'}, id: patient.id}
      response.status.should == 302 # Redirects to show page for the patient
      patient.reload.allergies.should eq 'none'
    end

    #it 'splits date and time for form' do
    #  get :edit, { id: patient.id}
    #  birth_date = (assigns(:patient) || assigns(:record))[:birth_date]
    #  puts birth_date
    #  birth_date.class.should eq Date
    #end
  end

end
