class VisitsController < ApplicationController
  before_filter :authenticate_user!

  active_scaffold :visit do |conf|
  end
end
