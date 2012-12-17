require 'spec_helper'
include Warden::Test::Helpers

module RequestHelpers
  def create_logged_in_user
    user = User.create(email: 'test@example.com', password: 'passxxx', username: 'SomeUser')
    login(user)
    user
  end

  def login(user)
    login_as user, scope: :user
  end
end