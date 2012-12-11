# == Schema Information
#
# Table name: prescriptions
#
#  id          :integer          not null, primary key
#  patient_id  :integer
#  provider_id :integer
#  date        :datetime
#  filled      :boolean
#  confirmed   :boolean
#  void        :boolean
#  weight      :float
#  height      :float
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require "spec_helper"

describe Prescription do

  describe "Validates record" do
    let(:prescription) {FactoryGirl.build(:prescription)}

    it "with all required data is valid" do
      prescription.should be_valid
    end

    it { should validate_presence_of(:date)}

    it { should validate_presence_of(:patient_id)}
    it { should validate_presence_of(:provider_id)}

    it 'marks future date invalid' do
      prescription.date = Date.tomorrow.to_datetime
      prescription.should_not be_valid
      prescription.errors[:date].should include "cannot be in the future"
    end
  end

  describe '"Include?" finds prescription_item matching drug name' do
    let(:prescription) {FactoryGirl.create(:prescription)}
    let(:item) {FactoryGirl.create(:prescription_item, prescription: prescription, drug: 'ampicillin')}

    it 'finds matching item' do
      item
      prescription.include?('ampicillin').should eq item
    end

    it 'returns nil if no item matches on drug name' do
      item
      prescription.include?('Nothing').should be_nil
    end
  end

  describe 'Interaction warnings' do
    before(:each) do
    @prescription = FactoryGirl.create(:prescription)
    @item_1 = FactoryGirl.create(:prescription_item, prescription: @prescription, drug: 'phenobarbitone')
    @item_2 = FactoryGirl.create(:prescription_item, prescription: @prescription, drug: 'kaletra')
    end

    context 'when interacting drugs are both present' do
      before(:each) do
        @matching = @prescription.interaction_warning([@item_1.drug], [@item_2.drug])
        @nominal_warning = "Potential drug interaction: #{@item_1.drug}, #{@item_2.drug}."
      end

      it 'returns drug names when interacting drugs are both present' do
        @matching.should eq [@item_1.drug, @item_2.drug]
      end

      it 'adds message to warnings when can be overridden' do
        @prescription.interaction_warning([@item_1.drug], [@item_2.drug], override: true)
#        puts @prescription.warnings
        @prescription.warnings.should include @nominal_warning
      end

      it 'adds message to errors when cannot be overriden' do
        @prescription.errors.messages[:Caution].should include @nominal_warning
      end
    end

    context 'when interacting drugs are not both present' do

      it 'returns nil when first drug is not found' do
        matching = @prescription.interaction_warning(['Nothing'], [@item_2.drug])
        matching.should be_nil
      end

      it 'returns nil when second drug is not found' do
        matching = @prescription.interaction_warning([@item_1.drug], ['Nothing'])
        matching.should be_nil
      end

    end

  end
end
