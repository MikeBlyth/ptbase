require "spec_helper"
require "latest_parameters"
require "anthropometrics"

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
      @recent_labs = FactoryGirl.create(:lab, :lo_cd4, :anemic, patient: @patient, date: @recent)
      @old_labs = FactoryGirl.create(:lab, :hi_cd4, patient: @patient, date: @old)
      @recent_visit = FactoryGirl.create(:visit, date: @old, patient: @patient,
                                         height: 120, weight: 30, meds: "Meds recent", hiv_stage: 3)
      @old_visit = FactoryGirl.create(:visit, date: @old, patient: @patient,
                                      height: 119, weight: 35, meds: "Meds old", hiv_stage: 1 )
    end

    it 'finds new values when all are present' do
      latest = LatestParameters.new(@patient).load_from_tables
      [:weight, :height, :meds,:hiv_stage].each do |param|
        latest[param][:value].to_s.should eq @recent_visit.send(param).to_s
      end
      [:cd4, :cd4pct, :hct].each do |param|
        latest[param][:value].to_s.should eq @recent_labs.send(param).to_s
      end
    end

    it 'finds uses latest non-nil when ones in most recent record are missing' do
      @recent_labs.update_attributes(cd4: nil, hct: nil, cd4pct: nil)
      @recent_visit.update_attributes(weight: nil, height: nil, meds: nil, hiv_stage: nil)
      latest = LatestParameters.new(@patient).load_from_tables
      [:weight, :height, :meds,:hiv_stage].each do |param|
        latest[param][:value].to_s.should eq @old_visit.send(param).to_s
      end
      [:cd4, :cd4pct, :hct].each do |param|
        latest[param][:value].to_s.should eq @old_labs.send(param).to_s
      end
    end

    it 'finds new values when all are present' do
      latest = LatestParameters.new(@patient).load_from_tables
      [:weight, :height, :meds,:hiv_stage].each do |param|
        latest[param][:value].to_s.should eq @recent_visit.send(param).to_s
      end
      [:cd4, :cd4pct, :hct].each do |param|
        latest[param][:value].to_s.should eq @recent_labs.send(param).to_s
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
      latest = LatestParameters.new(@patient).load_from_tables.add_anthropometrics
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
        latest = LatestParameters.new(@patient).load_from_tables.add_anthropometrics
        latest[:pct_expected_ht][:value].should eq missing
        latest[:pct_expected_wt][:value].should eq pct_expected_weight(age: @patient.age_years,
                                                                       sex: @patient.sex, weight: @visit.weight)
        latest[:pct_expected_wt_for_ht][:value].should eq missing
      end

      it 'when weight is missing' do
        @visit = FactoryGirl.create(:visit, :recent, patient: @patient, height: 120, weight: nil)
        latest = LatestParameters.new(@patient).load_from_tables.add_anthropometrics
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
      @labs = FactoryGirl.build(:lab, :lo_cd4, :anemic, patient: @patient, date: Date.today - 2.years)
    end

    let(:latest) {LatestParameters.new(@patient).load_from_tables}

    it 'adds reminders when no specified lab within time limit' do
      @labs.save
      latest[:hct][:value].should_not be_nil
      latest.add_reminder(item: :hct)
      latest.add_reminder(item: :cd4)
      latest[:comment_hct][:value].should eq "patient is due for hct check"
      latest[:comment_hct][:label].should eq "Note"
      latest[:comment_cd4][:value].should eq "patient is due for cd4 check"
    end

    it 'does not add reminders when last specified lab is within time limit' do
      @labs.date = Date.today
      @labs.save
      latest[:hct][:value].should_not be_nil
      latest.add_reminder(item: :hct)
      latest.add_reminder(item: :cd4)
      latest[:comment_hct][:value].should be_nil
      latest[:comment_cd4][:value].should be_nil
    end

    it 'uses custom message when given' do
      @labs.save
      latest[:hct][:value].should_not be_nil
      latest.add_reminder(item: :hct, message: 'Other message for $')
      latest[:comment_hct][:value].should eq 'Other message for hct'
      latest[:comment_hct][:label].should eq "Note"
    end

  end

end

