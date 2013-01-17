require 'spec_helper'
require 'patient_presenter'
require 'latest_parameters'
require 'anthropometrics'

describe PatientPresenter do
  include ActionView::TestCase::Behavior    # See RailsCast 287. This makes view available as local variable

  let(:patient)   {FactoryGirl.create(:patient)}
  let(:presenter) {PatientPresenter.new(patient,view)} # No template ... what are templates used for in Presenters??

  it 'returns correct alive/dead status' do
    presenter.alive_or_dead.should match 'alive'
    patient.death_date = '2010-01-01'
    presenter.alive_or_dead.should eq  "died on #{patient.death_date}"
  end

  describe 'health data comments string' do

    it 'returns "Add comment" when no comments' do
      presenter.comments.should match /<td id='attn'>.*Add comment.*<\/td>/
      patient.comments = 'Some comments'
      presenter.comments.should match "<td id='attn', class='attention'>Some comments</td>"

    end

    it 'returns comments string when they exist' do
      patient.comments = 'Some comments'
      presenter.comments.should match "<td id='attn', class='attention'>Some comments</td>"
    end
  end

  describe 'allergies' do

    it 'returns patient allergies when they exist' do
      patient.allergies = 'Penicillin'
      presenter.allergies.should eq "<tr><td class='med_info_label'>Allergies:</td><td class='attention'>Penicillin</td></tr>"
    end

    it 'returns nothing when field is empty' do
      patient.allergies = nil
      presenter.allergies.should be_nil
    end
  end

  describe 'hemoglobin type' do

    it 'returns patient hemoglobin_type when known' do
      patient.hemoglobin_type = 'AS'
      presenter.hemoglobin_type.should match "<tr><td class='med_info_label'>Hb type:<\/td><td .*>AS</td><\/tr>"
    end

    it 'uses special CSS class for hemoglobin SS' do
      patient.hemoglobin_type = 'SS'
      presenter.hemoglobin_type.should match "class='attention'"
    end

    it 'returns nothing when field is empty' do
      patient.hemoglobin_type = nil
      presenter.hemoglobin_type.should be_nil
    end
  end

  
  describe 'HIV status' do

    it 'returns nothing when field is empty' do
      patient.hiv_status = nil
      patient.maternal_hiv_status = nil
      presenter.hiv_status.should be_nil
    end

    it 'returns patient hiv_status when known' do
      patient.hiv_status = 'negative'
      patient.maternal_hiv_status = nil
      presenter.hiv_status.should
        match Regexp.new "<tr><td class='med_info_label'>HIV status:<\/td><td .*>negative</td><\/tr>",  Regexp::MULTILINE
      presenter.hiv_status.should_not match "class='attention'"
    end

    it 'highlights HIV positive status' do
      patient.hiv_status = 'positive'
      presenter.hiv_status.should match "class='attention'"
    end

    context "when mother's status is known" do

      it 'appends mother''s status' do
        patient.hiv_status = 'negative'
        patient.maternal_hiv_status = 'negative'
        presenter.hiv_status.should match Regexp.new "negative.*mother.*negative", Regexp::MULTILINE
        presenter.hiv_status.should_not match "class='attention'"
      end

      it 'highlights when mother is HIV positive' do
        patient.hiv_status = 'negative'
        patient.maternal_hiv_status = 'positive'
        presenter.hiv_status.should match Regexp.new "attention.*negative.*mother.*positive", Regexp::MULTILINE
      end

    end
  end

  describe 'show_latest_parameters' do
    before(:each) do
      @latest = LatestParametersFactory.new(patient: patient, hct: 25, cd4: 500)
      patient.stub(:latest_parameters => @latest)
    end

    it 'formats row (<tr>) properly' do
      result = presenter.show_latest_parameters(:hct)
      result.should match "<tr><td class=\"med_info_label\">Latest hct:</td><td class=\"med_info_text\">.*25.*#{@latest[:hct][:date]}.*</td></tr>"
    end

    it 'shows multiple results' do
      result = presenter.show_latest_parameters(:hct, :cd4)
      result.should match "<tr><td class=\"med_info_label\">Latest hct:</td><td class=\"med_info_text\">.*25.*#{@latest[:hct][:date]}.*</td></tr>"
      result.should match "<tr><td class=\"med_info_label\">Latest CD4:</td><td class=\"med_info_text\">.*500.*#{@latest[:hct][:date]}.*</td></tr>"
    end

    it 'handles value with no date' do
      hct_date = @latest[:hct][:date].to_s
      @latest[:hct][:date] = nil
      result = presenter.show_latest_parameters(:hct)
      result.should match "<tr><td class=\"med_info_label\">Latest hct:</td><td class=\"med_info_text\">.*25.*</td></tr>"
      result.should_not match hct_date

    end

    it 'adds comment when there is one' do
      @latest[:hct][:comment] = 'My comment'
      result = presenter.show_latest_parameters(:hct)
      result.should match "<span class=\"item_comment\">My comment</span>"

    end
  end

  describe 'Immunization alerts' do
    it 'adds notice when Hib immunization is needed' do
      Immunization.stub(:hib_needed => true)
      presenter.immunization_alerts.should match "Hib .*needed"
    end
  end

  describe 'Anthropometric summary' do
    before(:each) do
      patient.birth_date = Date.today - 5.years
      @latest = LatestParametersFactory.new(patient: patient, hct: 25, cd4: 500)
      patient.stub(:latest_parameters => @latest)
    end

    it 'describes % expected height, %expected weight, and % expected weight for height' do
      weight = 18
      height = 115
      @latest.change(:weight, weight, Date.today)
      @latest.change(:height, height, Date.today)
      params = {weight: weight, height: height, sex: patient.sex, age: patient.age_years}
      pct_expected_height = pct_expected_height(params)
      pct_expected_weight = pct_expected_weight(params)
      pct_expected_weight_for_height = pct_expected_weight_for_height(params)
      results = presenter.anthropometric_summary
      puts "Anthro = #{results}"
      results.should match "Weight is #{pct_expected_weight}% of expected for age"
      results.should match regexcape "Height (#{height} cm) is #{pct_expected_height}% of expected for age"
      results.should match "Weight is #{pct_expected_weight_for_height}% of expected for height"
    end
  end

  describe 'Shows beginning/ending of drug courses' do
    before(:each) do
      patient.stub(:arv_begin => Date.new(2010,1,1))
      patient.stub(:arv_stop => Date.new(2012,1,1))
      patient.stub(:anti_tb_begin => Date.new(2011,1,1))
      patient.stub(:anti_tb_stop => Date.new(2011,6,1))
    end

    it 'shows beginning and end of ARV course' do
      presenter.begin_stop_course(course: :arv, label: 'ARV').
          should match "Began ARV 1 Jan (20)?10, stopped 1 Jan (20)?12"
    end

    it 'shows beginning when course is not finished' do
      patient.stub(:arv_stop => nil)
      results = presenter.begin_stop_course(course: :arv, label: 'ARV')
      results.should match "Began ARV 1 Jan (20)?10"
      results.should_not match "stopped"
    end

  end
end