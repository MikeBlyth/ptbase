class LabsFactory
  attr_reader :patient, :provider, :request, :lab_group, :services

  def initialize(options={})
    @patient = options[:patient] || Patient.first || FactoryGirl.create(:patient)
    @provider = options[:provider] || Provider.first || FactoryGirl.create(:provider)
    request_date = options[:date]
    @request = options[:request] ||
        FactoryGirl.create(:lab_request, patient: @patient, provider: @provider, date: request_date)
    @lab_group = options[:lab_group] || LabGroup.first || FactoryGirl.create(:lab_group)
    @services = options[:lab_services] || LabService.all
  end

  # add_labs({abbrev: 'hct' [, date: date] [, abnormal: true] [, panic: true] [, result: result]}, {...}, {...})
  def add_labs(*labs)
    added = []
    labs.each do |lab|
      lab[:date] ||= @request.date
      abbrev = lab[:abbrev] || lab[:lab] || lab[:name]
#      request = get_request_for_date(a_date)
      service = get_service_by_abbrev(abbrev)
      create_options = lab.select {|k,v| ![:abbrev, :lab, :name].include? k}.
                       merge({lab_request: request, lab_service: service})
#puts "create_options=#{create_options}"
      added << FactoryGirl.create(:lab_result, create_options)
    end
    return added
  end

  def date
    @request.date
  end

  def date=(new_date)
    @request = get_request_for_date(new_date)
  end

  def lab_abbrevs
    @services.map {|s| s.abbrev}
  end

  def get_service_by_abbrev(abbrev)
    if service = @services.find {|s| s.abbrev == abbrev}
      return service
    else
      service = FactoryGirl.create(:lab_service, abbrev: abbrev, lab_group: @lab_group)
      @services << service
      return service
    end
  end

  def get_request_for_date(a_date)
    a_date == @request.date ? @request : FactoryGirl.create(:lab_request, patient: @patient, provider: @provider,
                                                          date: a_date)
  end
end