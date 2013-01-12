# == Schema Information
#
# Table name: lab_results
#
#  id             :integer          not null, primary key
#  lab_request_id :integer
#  lab_service_id :integer
#  result         :string(255)
#  date           :datetime
#  status         :string(255)
#  abnormal       :boolean
#  panic          :boolean
#  comments       :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class LabResult < ActiveRecord::Base
  attr_accessible :comments, :lab_request_id, :lab_request,  :result, :date,
                  :lab_service_id, :lab_service, :status, :abnormal, :panic, :comments
  belongs_to :lab_request
  belongs_to :lab_service
  has_one :patient, through: :lab_request

  # Get selected labs (by abbrevs) for patient covering "days_since" days from present
  # E.g. get_selected_labs_by_date(patient, 45, :CD4, :hct, 'cd4%')
  # Returned value is relation with each record containing result, lab_service_id (i.e. which
  # lab such as hct), and the date (datetime) of the result
  # If days_since is nil, all specified labs are returned (without a date window)
  # ToDo -- move this off into a query object or something like that?
  def self.get_selected_labs_by_date(patient, days_since=nil, *selected_labs)
    target_abbrevs = selected_labs.map{|v| "'#{v.to_s.downcase}'"}.join(',') # " 'cd4', 'cd4%' ... "
    target_labs = LabService.where("LOWER(lab_services.abbrev) IN (#{target_abbrevs})").
        map {|s| s.id}
    since_date = days_since ?  Date.today - days_since.days : Date.today - 100.years
    self.joins(:patient, :lab_request).
        where('patients.id = ?', patient.id).
        where('date(lab_results.date) > ?', since_date ).
        where(:lab_service_id => target_labs).
        select('result, lab_service_id, date')
  end

  def to_s
    "#{lab_service.abbrev}=#{result || 'pending'} (#{date})"
  end
end

