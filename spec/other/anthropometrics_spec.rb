require "spec_helper"
require "anthropometrics.rb"
include Anthropometrics

describe  Anthropometrics do

  describe "Body Surface Area" do

    it 'calculates BSA from weight alone' do
      body_surface_area(weight: 2.0).should be_within(0.02).of(0.16)
      body_surface_area(weight: 5.0).should be_within(0.03).of(0.30)
      body_surface_area(weight: 20.0).should be_within(0.08).of(0.8)
      body_surface_area(weight: 50.0).should be_within(0.15).of(1.47)
    end

    it 'calculates BSA from height and weight' do
      body_surface_area(height: 50.0, weight: 3.0).should be_within(0.02).of(0.2)
      body_surface_area(height: 130.0, weight: 30.0).should be_within(0.1).of(1.04)
      body_surface_area(height: 170.0, weight: 75.0).should be_within(0.12).of(1.84)
    end

    it 'returns nil if weight is missing' do
      body_surface_area(height: 50.0).should be_nil
    end

  end
end
