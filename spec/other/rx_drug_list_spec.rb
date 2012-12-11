require 'spec_helper'
require 'rx_drug_list'

describe RxDrugList do
  let(:drug) {'PCN'}
  let(:new_prescription) {FactoryGirl.create(:prescription, :recent)}
  let(:old_prescription) {FactoryGirl.create(:prescription, :old)}
  let(:new_item) {FactoryGirl.create(:prescription_item, drug: drug, :prescription => new_prescription)}
  let(:old_item) {FactoryGirl.create(:prescription_item, drug: drug, :prescription => old_prescription)}
  let(:list) {RxDrugList.new}

  it 'initializes hash if given' do
    new = RxDrugList.new({:cat => :meow, :dog => :bark})
    new.class.should eq RxDrugList
    new[:cat].should eq :meow
  end

  it 'initializes empty hash if no args given to new' do
    RxDrugList.new.should be_empty
  end

  describe 'add_item' do

    it 'adds it when drug is not already in list' do
      list.add_item(new_item)
      list.count.should eq 1
      list[new_item.drug].should eq new_item
    end

    it 'replaces existing entry when this prescription is newer' do
      list.add_item(old_item)
      list.add_item(new_item)
      list[drug].should eq new_item
    end

    it 'ignores prescription item when existing one is newer' do
      list.add_item(new_item)
      list.add_item(old_item)
      list[drug].should eq new_item
    end

  end

  describe 'adds array (relation) of prescriptions' do

    it 'adds items in each prescription' do
      @patient = FactoryGirl.create(:patient)
      @provider = FactoryGirl.create(:provider)
      p1 = FactoryGirl.create(:prescription, patient: @patient, provider: @provider)
      2.times {FactoryGirl.create(:prescription_item, prescription: p1) }
      p2 = FactoryGirl.create(:prescription)
      2.times {FactoryGirl.create(:prescription_item, prescription: p2) }
      list.add_prescriptions(Prescription.all)
      list.count.should eq 4
    end
  end

  describe 'lists current drugs' do
    it 'includes only drugs when date+duration >= today' do
      old_item.drug = 'old drug'
      list.add_item(new_item)
      list.add_item(old_item)
      current = list.current
      current.class.should == RxDrugList
      current.count.should eq 1
      current.should include drug
      current.should_not include 'old drug'
    end
  end

  describe "formatted"

    it "should produce array of formatted string" do
      item = new_item
      list.add_item(item)
      itemB = FactoryGirl.create(:prescription_item, drug: 'BBB', :prescription => new_prescription)
      list.add_item(itemB)
# puts list.formatted
      list.formatted[0].should eq "#{item.drug} #{item[:dose]} #{item[:units]} #{item[:route]} q#{item[:interval]}h x #{item[:duration]} days."
      list.formatted[1].should eq "#{itemB.drug} #{itemB[:dose]} #{itemB[:units]} #{itemB[:route]} q#{itemB[:interval]}h x #{itemB[:duration]} days."
    end
end
