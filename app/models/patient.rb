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
require 'birth_date'
include Anthropometrics

class Patient < ActiveRecord::Base
  include DateValidators

  has_one  :health_data
  has_many :visits, dependent: :delete_all
  has_many :labs, dependent: :delete_all
  has_many :admissions, dependent: :delete_all
  has_many :immunizations, dependent: :delete_all
  has_many :prescriptions, dependent: :delete_all
#  has_many :prescription_items, through: :prescriptions
  has_many :photos, dependent: :delete_all
  has_many :visits, dependent: :delete_all
  attr_accessible :birth_date, :birth_date_exact, :death_date, :first_name, :ident, :last_name, :other_names,
                  :sex
  validates_presence_of :last_name, :ident, :birth_date
  validates_uniqueness_of :ident
  validate :valid_birth_date

  delegate "hiv_status", "maternal_hiv_status", "allergies", "comments",
           'hiv?', 'hiv_status_word', 'hiv_pos_mother', 'current_drugs', 'current_drugs_formatted',
           to: :health_data

############ NAME METHODS
  def name
    initial = other_names.blank? ? '' : " #{other_names[0]}."
    return first_name+initial+ ' ' + last_name
  end

  def name_id
    return self.name + " [#{self.ident}]"
  end

  def name_last_first
    "#{last_name}, #{first_name}"
  end

  def name_last_first_id
    return self.name_last_first + " [#{self.ident}]"
  end

  ############### HIV STATUS METHODS
  # ToDo - Clean up this use of single character codes. Should be elsewhere in a constant or something.

  # ToDo - move to health_data
  def arv_begin
    most_recent = self.visits.find(:first,
                                     :conditions => "arv_status = 'B' ",
                                     :order => "date DESC" )
    if most_recent.nil?                # if we didn't find B (Begin), take the oldest C (continue)
      most_recent = self.visits.find(:first,
                                       :conditions => "arv_status = 'C' ",
                                       :order => "date" )

    end
    most_recent = most_recent.date unless most_recent.nil?
  end

  # TODO: Outdated? See above
  def arv_stop
    most_recent = self.visits.find(:first,
                                     :conditions => "arv_status = 'X' ",
                                     :order => "date DESC" )
    most_recent = most_recent.date unless most_recent.nil?
  end

  # TODO: Outdated? See above
  def current_arv_regimen
    last_vis = self.last_visit
    return '' if last_vis.nil?
    return last_vis.arv_reg_str
  end

  # TODO: Outdated? See above
  def current_arv_regimen_began    # return date this regimen began, by whatever means we can find or guess
    visits = self.visits.find(:all, :order => "date DESC") # if this gets to be too slow, could use SQL query to get only the needed columns
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
    most_recent = self.visits.find(:first,
                                     :conditions => "anti_tb_status = 'B' ",
                                     :order => "date DESC" )
    if most_recent.nil?                # if we didn't find B (Begin), take the oldest C (continue)
      most_recent = self.visits.find(:first,
                                       :conditions => "anti_tb_status = 'C' ",
                                       :order => "date" )

    end
    most_recent = most_recent.date unless most_recent.nil?
  end

  # TODO: Outdated? See above
  def anti_tb_stop
    most_recent = self.visits.find(:first,
                                     :conditions => "anti_tb_status = 'X' ",
                                     :order => "date DESC" )
    most_recent = most_recent.date unless most_recent.nil?
  end

  # THIS SECTION GETS THE MOST RECENT VALUES OF VARIOUS KINDS FOR A GIVEN PATIENT


  # ToDo - Lots of refactoring of this monster method
  # TODO: Not tested
  def get_latest_parameters()
    # may want to change this to let desired parameters be passed rather than being specified here in the method
    # This could probably be optimized, not having to do separate SQL query for each parameter
    # Should look in the latest visit (see end of this procedure) for height, weight, etc. and
    # only look at other visits (get_last) if they're not recorded in the latest visit.

    latest_parameters = LatestParameters.new(self).load_from_tables

    # Calculate expected weight, ht, wt for height etc.
    weight_date = latest_parameters[:weight][:date]
    anthro_inputs = {
      sex: self.sex,
      height: latest_parameters[:height][:value],
      weight: latest_parameters[:weight][:value],
      age: age_on_date_in_years(weight_date)
    }
    latest_parameters[:pct_expected_ht] = {:value => pct_expected_height(anthro_inputs) || '?'}
    latest_parameters[:pct_expected_wt] = {:value => pct_expected_weight(anthro_inputs) || '?'}
    latest_parameters[:pct_expected_wt_for_ht] = {:value => pct_expected_weight_for_height(anthro_inputs) || '?'}

      #   Reminders about needed labs
    if self.hiv?
      today = DateTime.now
      hct_date = latest_parameters[:hct][:date] || NILDATE
      cd4_date = latest_parameters[:cd4][:date] || NILDATE
      if today - hct_date > 150  # 5 months
        latest_parameters[:comment_hct] = {:label => "Note", :value => "patient is due for hematocrit check"}
      end
      if today - cd4_date > 150  # 5 months
        latest_parameters[:comment_cd4] = {:label => "Note", :value => "patient is due for CD4 check"}
      end
    end
    latest_visit = 	self.visits.find(:first, :order => "date DESC")
    latest_parameters[:latest_visit] = latest_visit
    return latest_parameters
  end

  def last_visit
    most_recent = self.visits.find(:first,
                                     :order => "date DESC" )
  end

  def next_appt
    return nil if self.last_visit.nil?
    return self.last_visit.next_visit
  end

  ############### OTHER METHODS

  def date
    birth_date
  end

  def alive
    not died
  end


end
