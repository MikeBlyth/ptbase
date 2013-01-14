require "#{Rails.root}/spec/factories/labs_factory.rb"

describe LabsFactory do

  it 'initializes without options' do
    f = LabsFactory.new
    f.patient.class.should == Patient
    f.provider.class.should == Provider
    f.request.class.should == LabRequest
    f.request.date.to_date.should == Date.today
    f.lab_group.class.should == LabGroup
    f.services.should == []
  end

  it 'initializes with options' do
    patient = FactoryGirl.create(:patient)
    provider = FactoryGirl.create(:provider)
    request = FactoryGirl.create(:lab_request, patient: patient, provider: provider)
    lab_group = FactoryGirl.create(:lab_group)
    lab_service = FactoryGirl.create(:lab_service, lab_group: lab_group)
    f = LabsFactory.new(patient: patient, provider: provider, request: request, lab_group: lab_group,
              services: [lab_service])
    f.patient.should eq patient
    f.provider.should eq provider
    f.request.should eq request
    f.lab_group.should eq lab_group
    f.services.should eq [lab_service]
  end

  it 'uses first existing provider and patient if not specified' do
    patient = FactoryGirl.create(:patient)
    provider = FactoryGirl.create(:provider)
    f = LabsFactory.new
    f.patient.should eq patient
    f.provider.should eq provider
    Patient.count.should eq 1
    Provider.count.should eq 1
  end

  it 'setting date causes new request to be created' do
    f = LabsFactory.new
    f.date=DateTime.now - 1.year
    f.request.date.to_date.should eq Date.today - 1.year
  end

  it 'setting date gives that date to subsequent labs' do
    f = LabsFactory.new
    new_date = DateTime.now - 1.year
    f.date = new_date
    f.add_labs({lab: :hct}).first.date.should eq new_date
  end

  it 'adds labs' do
    f = LabsFactory.new
    f.add_labs({lab: 'hct'}, {lab: 'cd4'})
    labs = f.patient.lab_results
    labs.map {|lab| lab.lab_service.abbrev}.sort.should == ['cd4', 'hct']
    f.lab_abbrevs.sort.should eq ['cd4', 'hct']
  end

  it 'adds options when creating labs' do
    f = LabsFactory.new
    f.add_labs({lab: 'hct', panic: true})
    labs = f.patient.lab_results.first.panic.should be_true
  end

  it 'adds lab with custom date' do
    f = LabsFactory.new
    some_date = DateTime.now - 1.year
    f.add_labs({lab: 'hct', date: some_date})
    f.patient.lab_results.last.reload.date.should eq some_date
  end
end