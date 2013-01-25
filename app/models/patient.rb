# == Schema Information
#
# Table name: patients
#
#  id                  :integer          not null, primary key
#  first_name          :string(255)
#  last_name           :string(255)
#  middle_name         :string(255)
#  birth_date          :datetime
#  death_date          :date
#  birth_date_exact    :boolean
#  ident               :string(255)
#  sex                 :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  residence           :string(255)
#  phone               :string(255)
#  caregiver           :string(255)
#  hiv_status          :string(255)
#  maternal_hiv_status :string(255)
#  allergies           :string(255)
#  hemoglobin_type     :string(255)
#  comments            :string(255)
#


require 'rx_drug_list'
require 'anthropometrics'
require 'latest_parameters'
require 'birth_date'
include Anthropometrics

class Patient < ActiveRecord::Base
  include DateValidators
  include NamesHelper

  attr_accessible :first_name, :ident, :last_name, :middle_name, :sex, :residence, :phone, :caregiver, :birth_date,
                  :death_date, :birth_date_text, :birth_date_exact,:death_date,
                  :allergies, :hemoglobin_type, :hiv_status, :maternal_hiv_status

  attr_writer :birth_date_text

  has_many :visits
  has_many :lab_requests
  has_many :lab_results
  has_many :problems, dependent: :delete_all
  has_many :admissions
  has_many :immunizations, dependent: :delete_all
  has_many :prescriptions
  has_many :prescription_items, through: :prescriptions
  has_many :photos, dependent: :delete_all
  has_many :visits

  validates_presence_of :last_name, :ident, :birth_date
  validates_uniqueness_of :ident
  before_validation :save_birth_date_text
  validate :valid_birth_date



############ NAME METHODS
  def to_s
    name_id
  end

  def to_label
    name_id
  end

  # ToDo - Seems this should be in helpers, but it's needed by GrowthChart too, -- where is best location?
  def name_id
    return self.name + " [#{self.ident}]"
  end

  ## Demographics
  def died
    not death_date.nil?
  end

  ############### DRUG REGIMEN STATUS METHODS
  #[ not on ART = 0 ],                        
  #[ preparing = P ],                         
  #[ begin today = B ],                       
  #[ continue = C ],                         
  #[ stop today = X ],                       
  #[ change today = V ] ],                   
  # ToDo - Clean up this use of single character codes. Should be elsewhere in a constant, class or something.
  # ToDo - Fix so it does not need multiple DB queries

  # arv_ and anti_tb_begin and _end return the dates for the LATEST regimen, not the earliest
  # so if someone started arv then stopped and began again later, it is the later date that will be
  # returned
  def arv_begin
    most_recent = self.visits.where(arv_status: ['B', 'C']).order("date DESC" ).first
    most_recent ? most_recent.date  : nil
  end

  # TODO: Outdated? See above
  def arv_stop
    most_recent = self.visits.where(arv_status: 'X').where("date > ?", arv_begin).order("date DESC" ).first
    most_recent ? most_recent.date  : nil
  end

  # TODO: Outdated? See above
  def current_arv_regimen
    last_visit ? last_visit.arv_reg_str : ''
  end

  # TODO: Outdated? See above
  def anti_tb_begin
    most_recent = self.visits.where(anti_tb_status: ['B', 'C']).order("date DESC" ).first
    most_recent ? most_recent.date  : nil
  end

  # TODO: Outdated? See above
  def anti_tb_stop
    most_recent = self.visits.where(anti_tb_status: 'X').where("date > ?", anti_tb_begin).order("date DESC" ).first
    most_recent ? most_recent.date  : nil
  end

  def last_visit
    @last_visit || self.visits.latest
  end

  # TODO: Outdated? See above
  def current_arv_regimen_began    # return date this regimen began, by whatever means we can find or guess
    visits = self.visits.order("date DESC") # if this gets to be too slow, could use SQL query to get only the needed columns
    return nil if visits.empty?
    current_regimen = visits[0].arv_regimen    # this is the latest reported regimen
    return nil if current_regimen.blank?        # nothing reported
    emptycount = 0
    max_allowed_empty_count = 2
    for visit in visits do
      # first time through loop, first_date will be set to the date of the most recent visit
      first_date = visit.date if visit.arv_regimen == current_regimen   # keep track of earlier visits with same regimen
      break if visit.arv_status == 'V' || 		# regimen explicitly changed
          (!visit.arv_regimen.blank? && visit.arv_regimen != current_regimen) ||	# non-blank, different regimen
          visit.arv_regimen.blank? && ['O', 'X', 'P', 'V'].include?(visit.arv_status)  # empty, plus non-continuing status
      emptycount = emptycount + 1 if visit.arv_regimen.blank? && visit.arv_status != 'C'
      break if emptycount > max_allowed_empty_count   # too many "empty" regimens ==> assume not on anything
    end
    return first_date #.strftime('%d %b %Y')
  end

  # TODO: Outdated? See above

  # THIS SECTION GETS THE MOST RECENT VALUES OF VARIOUS KINDS FOR A GIVEN PATIENT

  def latest_parameters
    @latest_parameters || update_latest_parameters
  end

  # ToDo - CD4 & CD4 pct don't need to be added to non-HIV patients
  def update_latest_parameters
    @latest_parameters = LatestParameters.new(self)
    @latest_parameters.load_from_labs(:cd4, :cd4pct, :hct)
    @latest_parameters.add_anthropometrics

    #   Reminders about needed labs
    if self.hiv?
      @latest_parameters.add_reminder(param: :hct)
      @latest_parameters.add_reminder(param: :cd4)
    end

    return @latest_parameters
  end

  def next_appt
    last_visit ? last_visit.next_visit : nil
  end

  ############### OTHER METHODS

  def birth_date_text
    @birth_date_text || birth_date.to_s(:day_mon_year)
  end

  def save_birth_date_text
    self.birth_date = validate_birth_date_text unless  @birth_date_text.blank?
    #binding.pry
  end

  def date
    birth_date
  end

  def alive
    not died
  end

  # Has HIV concern if own status is positive OR (mother's status is positive and own is not Negative)
  def hiv?
    return hiv_status == 'positive' ||
        (age_years < 18.months && hiv_pos_mother && hiv_status != 'negative')
  end

  def hiv_pos
    return hiv_status == 'positive'
  end

  def hiv_pos_mother # see hiv_pos;
    return self.maternal_hiv_status == 'positive'
  end

  def current_drugs
    recent_drugs(6).current
  end

  def current_drugs_formatted
    current_drugs.formatted
  end

  private

  def recent_drugs(since=3)
    recent_prescriptions = prescriptions.confirmed.valid.where('date >= ?', Date.today-since.months)
    RxDrugList.new.add_prescriptions(recent_prescriptions)
  end

  def validate_birth_date_text
    if @birth_date_text.blank?
      errors.add :birth_date_text, "cannot be blank"
      return nil
    end
    parsed = Time.zone.parse(@birth_date_text)
    if parsed
      return parsed
    else
      errors.add :birth_date_text, "cannot be parsed"
      return nil
    end
  rescue ArgumentError
    errors.add :birth_date_text, "is out of range"
    return nil
  end

  #def time_valid?(str)
  #  return false unless str =~ /\A\s*([0-9]{1,2}):([0-9]{2,2})(\s+|\Z)(am|pm)?/i
  #  hour, minute, am_pm = $1, $2, $4
  #  hour = hour.to_i
  #  minute = minute.to_i
  #  return false unless (0..59).include? minute
  #  return am_pm ? (1..12).include?(hour) : (0..23).include?(hour)
  #end
end
