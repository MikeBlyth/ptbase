class PatientsController < ApplicationController
  before_filter :authenticate_user!

  active_scaffold :patient do |conf|
  end
end
