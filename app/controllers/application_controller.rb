class ApplicationController < ActionController::Base
  protect_from_forgery
  # Add this when we figure out how to exempt the session#new and session#create actions
  # before_filter :authenticate_user!,

end
