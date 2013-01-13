# == Schema Information
#
# Table name: patients
#
#  id               :integer          not null, primary key
#  first_name       :string(255)
#  last_name        :string(255)
#  other_names      :string(255)
#  birth_date       :datetime
#  death_date       :date
#  birth_date_exact :boolean
#  ident            :string(255)
#  sex              :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#


require 'forwardable'
require 'anthropometrics'
require 'latest_parameters'
require 'birth_date'
include Anthropometrics

class Patient < ActiveRecord::Base
  include DateValidators
  include NamesHelper
  attr_accessible :first_name, :ident, :last_name, :other_names

  has_one  :health_data, dependent: :delete
  has_many :visits
  has_many :lab_requests
  has_many :lab_results, through: :lab_requests
  has_many :problems, dependent: :delete_all
  has_many :admissions
  has_one :immunization, dependent: :delete
  has_many :prescriptions
  has_many :prescription_items, through: :prescriptions
  has_many :photos, dependent: :delete_all
  has_many :visits

  attr_accessible :birth_date, :birth_date_exact, :death_date, :first_name, :ident, :last_name, :other_names,
                  :sex

  validates_presence_of :last_name, :ident, :birth_date
  validates_uniqueness_of :ident
  validate :valid_birth_date

  delegate "hiv_status", "maternal_hiv_status", "allergies", "comments",
           'hiv?', 'hiv_status_word', 'hiv_pos_mother', 'current_drugs', 'current_drugs_formatted',
           'hemoglobin_type',
           to: :health_data

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

  # ToDo - ** What is this for!?
  %w(pepfar residence phone caregiver).each do |attr|
    define_method attr do
      "*#{attr}*"
    end
  end

  ## Demographics
  def died
    not death_date.nil?
  end

  ############### HIV STATUS METHODS
  # ToDo - Clean up this use of single character codes. Should be elsewhere in a constant or something.

  # ToDo - move to health_data


  def arv_begin
    most_recent = self.visits.where(:conditions => "arv_status = 'B' ",
                                     :order => "date DESC" ).limit(1)
    if most_recent.nil?                # if we didn't find B (Begin), take the oldest C (continue)
      most_recent = self.visits.where(:conditions => "arv_status = 'C' ",
                                       :order => "date" ).limit(1)

    end
    most_recent ? most_recent.date  : nil
  end

  # TODO: Outdated? See above
  def arv_stop
    most_recent = self.visits.where(:conditions => "arv_status = 'X'",
                                     :order => "date DESC" ).limit(1)
    most_recent ? most_recent.date  : nil
  end

  # TODO: Outdated? See above
  def current_arv_regimen
    last_visit ? last_visit.arv_reg_str : ''
  end

  def last_visit
    @last_visit || self.visits.latest
  end

  # TODO: Outdated? See above
  def current_arv_regimen_began    # return date this regimen began, by whatever means we can find or guess
    visits = self.visits.order("date DESC") # if this gets to be too slow, could use SQL query to get only the needed columns
    return '' if visits.nil?
    current_regimen = visits[0].arv_regimen    # this is the latest reported regimen
    return '' if current_regimen.blank?        # nothing reported
    emptycount = 0
    max_allowed_empty_count = 2
    for visit in visits do
      # first time through loop, first_date will be set to the date of the most recent visit
      first_date = visit.date if visit.arv_regimen == current_regimen   # keep track of earlier visits with same regimen
      break if visit.arv_status == 'V' || 		# regimen explicitly changed
          (!visit.arv_regimen.blank? && visit.arv_regimen != current_regimen) ||	# non-blank, different regimen
          visit.arv_regimen.blank? && ['O', 'X', 'P', 'V'].include?(visit.arv_status)  # empty, plus non-continuing status
      emptycount = emptycount + 1 if visit.arv_regimen.blank?
      break if emptycount > max_allowed_empty_count   # too many "empty" regimens ==> assume not on anything
    end
    return first_date.strftime('%d %b %Y')
  end

  # TODO: Outdated? See above
  def anti_tb_begin
    most_recent = self.visits.where(:conditions => "anti_tb_status = 'B' ",
                                     :order => "date DESC" ).limit(1)
    if most_recent.nil?                # if we didn't find B (Begin), take the oldest C (continue)
      most_recent = self.visits.where(:conditions => "anti_tb_status = 'C' ",
                                       :order => "date" ).limit(1)

    end
    most_recent ? most_recent.date  : nil
  end

  # TODO: Outdated? See above
  def anti_tb_stop
    most_recent = self.visits.where(:conditions => "anti_tb_status = 'X' ",
                                     :order => "date DESC" ).limit(1)
    most_recent ? most_recent.date  : nil
  end

  # THIS SECTION GETS THE MOST RECENT VALUES OF VARIOUS KINDS FOR A GIVEN PATIENT

  def latest_parameters(items=nil)
    @latest_parameters || update_latest_parameters
  end

  def update_latest_parameters(selected=nil)
    @latest_parameters = LatestParameters.new(self).load_from_tables(:weight, :height, :meds,
                              :hiv_status)
    @latest_parameters.add_labs(:cd4, :cd4pct, :hct)
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

  def date
    birth_date
  end

  def alive
    not died
  end


end
