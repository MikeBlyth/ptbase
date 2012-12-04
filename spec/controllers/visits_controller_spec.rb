require "spec_helper"

describe VisitsController do

  context 'when user is not logged in' do

    it "should redirect to login path" do
      get :index
      response.should redirect_to new_user_session_path
    end
  end

end
