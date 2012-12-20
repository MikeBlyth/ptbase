class ApplicationController < ActionController::Base
  protect_from_forgery
  # Add this when we figure out how to exempt the session#new and session#create actions
  # before_filter :authenticate_user!,

  ActiveScaffold.set_defaults do |config|
    config.ignore_columns.add [:created_at, :updated_at, :lock_version]
    config.list.empty_field_text = '----'
#    config.theme = :gold
  end


end
