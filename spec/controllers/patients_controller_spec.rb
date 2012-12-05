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
      @user = User.create(email: 'test@example.com', password: 'passxxx', username: 'SomeUser')
      sign_in @user
      get :index
      response.status.should == 200
    end
  end

end
