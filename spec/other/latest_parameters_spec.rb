require "spec_helper"
require "latest_parameters"
require "anthropometrics"
require "#{Rails.root}/spec/factories/labs_factory"

describe LatestParameters do

  #
  describe 'initialization' do
    before(:each) {@patient = FactoryGirl.build_stubbed(:patient)}

    it 'includes patient, patient_id, and patient sex' do
      new_latest = LatestParameters.new(@patient)
      new_latest[:patient_id].should eq @patient.id
      new_latest[:patient].should eq @patient
      new_latest[:sex].should eq @patient.sex
    end

    it "includes patient's latest visit" do
      @recent_visit = FactoryGirl.create(:visit, :recent, patient: @patient)
      @old_visit = FactoryGirl.create(:visit, :old, patient: @patient)
      new_latest = LatestParameters.new(@patient)
      new_latest[:latest_visit].should eq @recent_visit
    end

  end

  describe 'get_latest_parameters()' do
    before(:each) do
      @recent = Date.today
      @old = Date.today - 6.months
      @patient = FactoryGirl.create(:patient)
      FactoryGirl.create(:health_data, patient: @patient)
      labs_factory = LabsFactory.new(patient: @patient, date: @recent)
      @nominal = {cd4: 300.0, hct: 28.0, cd4pct: 15.0}
      @recent_labs = labs_factory.add_labs({lab: 'cd4', result: @nominal[:cd4]},
                                           {lab: 'hct', result: @nominal[:hct]},
                                           {lab: 'cd4pct', result: @nominal[:cd4pct]})
      labs_factory.date = @old
      @old_labs = labs_factory.add_labs({lab: 'cd4', result: 500}, {lab: 'hct', result: 30}, {lab: 'cd4pct', result: 20})
      @recent_visit = FactoryGirl.create(:visit, date: @recent, patient: @patient,
                                         height: 120, weight: 30, meds: "Meds recent", hiv_stage: 3)
      @old_visit = FactoryGirl.create(:visit, date: @old, patient: @patient,
                                      height: 119, weight: 35, meds: "Meds old", hiv_stage: 1 )
    end

    it 'finds new values when all are present' do
      latest = LatestParameters.new(@patient)
      latest.load_from_labs(:cd4, :cd4pct, :hct)
      [:weight, :height, :meds,:hiv_stage].each do |param|
        latest[param][:value].to_s.should eq @recent_visit.send(param).to_s
      end
      [:cd4, :cd4pct, :hct].each do |param|
        latest[param][:value].should eq @nominal[param]
      end
    end

    it 'finds uses latest non-nil when ones in most recent record are missing' do
      @recent_visit.update_attributes(weight: nil, height: nil, meds: nil, hiv_stage: nil)
      latest = LatestParameters.new(@patient)
      [:weight, :height, :meds,:hiv_stage].each do |param|
        latest[param][:value].to_s.should eq @old_visit.send(param).to_s
      end
    end

    it 'finds new values when all are present' do
      latest = LatestParameters.new(@patient)
      latest.load_from_labs(:cd4, :cd4pct, :hct)
      [:weight, :height, :meds,:hiv_stage].each do |param|
        latest[param][:value].to_s.should eq @recent_visit.send(param).to_s
      end
      [:cd4, :cd4pct, :hct].each do |param|
        latest[param][:value].should eq @nominal[param]
      end
    end
  end


  describe 'adds anthropometric data' do
    before(:each) do
      @patient = FactoryGirl.create(:patient)
      FactoryGirl.create(:health_data, patient: @patient)
    end

    it 'adds all measures when required data is present' do
      @visit = FactoryGirl.create(:visit, :recent, patient: @patient, height: 120, weight: 30)
      latest = LatestParameters.new(@patient).add_anthropometrics
      latest[:pct_expected_ht][:value].should eq pct_expected_height(age: @patient.age_years,
                                                             sex: @patient.sex, height: @visit.height)
      latest[:pct_expected_wt][:value].should eq pct_expected_weight(age: @patient.age_years,
                                                                     sex: @patient.sex, weight: @visit.weight)
      latest[:pct_expected_wt_for_ht][:value].should ==
          pct_expected_weight_for_height(age: @patient.age_years, sex: @patient.sex,
                                         weight: @visit.weight, height: @visit.height)

    end

    describe 'handles missing data' do
      let(:missing) {'?'}

      it 'when height is missing' do
        @visit = FactoryGirl.create(:visit, :recent, patient: @patient, height: nil, weight: 30)
        latest = LatestParameters.new(@patient).add_anthropometrics
        latest[:pct_expected_ht][:value].should eq missing
        latest[:pct_expected_wt][:value].should eq pct_expected_weight(age: @patient.age_years,
                                                                       sex: @patient.sex, weight: @visit.weight)
        latest[:pct_expected_wt_for_ht][:value].should eq missing
      end

      it 'when weight is missing' do
        @visit = FactoryGirl.create(:visit, :recent, patient: @patient, height: 120, weight: nil)
        latest = LatestParameters.new(@patient).add_anthropometrics
        latest[:pct_expected_ht][:value].should eq pct_expected_height(age: @patient.age_years,
                                                                       sex: @patient.sex, height: @visit.height)
        latest[:pct_expected_wt][:value].should eq missing
        latest[:pct_expected_wt_for_ht][:value].should eq missing
      end

    end

  end

  describe 'Adds reminder' do
    before(:each) do
      @patient = FactoryGirl.create(:patient)
      FactoryGirl.create(:health_data, patient: @patient)
    end

    let(:latest) {LatestParameters.new(@patient)}

    it 'adds reminders when no specified lab within time limit' do
      latest[:hct] = {date: Date.today-1.year, value: 28}
      latest.add_reminder(item: :hct)
      latest.add_reminder(item: :cd4)
      latest[:comment_hct].should_not be_nil
      latest[:comment_cd4].should_not be_nil
      latest[:comment_hct][:value].should eq "patient is due for hct check"
      latest[:comment_hct][:label].should eq "Note"
      latest[:comment_cd4][:value].should eq "patient is due for cd4 check"
    end

    it 'does not add reminders when last specified lab is within time limit' do
      latest[:hct] = {date: Date.today, value: 28}
      latest.add_reminder(item: :hct)
      latest[:comment_hct].should be_nil
    end

    it 'uses custom message when given' do
      latest.add_reminder(item: :hct, message: 'Other message for $')
      latest[:comment_hct][:value].should eq 'Other message for hct'
      latest[:comment_hct][:label].should eq "Note"
    end

  end

  describe 'value function' do
    before(:each) do
      @latest = LatestParameters.new(Patient.new)
      @latest.insert_item({item: 'hct', value: 25, date: Date.today})
    end

    it 'returns item value when defined' do
      @latest.value('hct').should eq 25
    end

    it 'returns nil when item is defined' do
      @latest.value('something').should be_nil
    end

  end

end

