# == Schema Information
#
# Table name: patients
#
#  id                  :integer          not null, primary key
#  first_name          :string(255)
#  last_name           :string(255)
#  other_names         :string(255)
#  birth_date          :datetime
#  death_date          :date
#  birth_date_exact    :boolean
#  ident               :string(255)
#  sex                 :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  hiv_status          :string(255)
#  maternal_hiv_status :string(255)
#  allergies           :string(255)
#  comments            :text
#

# == Schema Information
#
# Table name: patients
#
#  id               :integer          not null, primary key
#  first_name       :string(255)
#  last_name        :string(255)
#  other_names      :string(255)
#  birth_date       :date
#  death_date       :date
#  birth_date_exact :boolean
#  ident            :string(255)
#  sex              :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require 'forwardable'

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

  delegate "hiv_status", "maternal_hiv_status", "allergies", "comments", to: :health_data

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
  #        Or just use the symbols :positive :negative, or 'pos', 'neg', etc.
  def hiv_pos  # use this method to isolate the actual coding of hiv field from program logic,
    return self.rv == 'P'
  end

  # Does this just mean HIV-related? If so, why not just 'hiv_pos || maternal_hiv == "P" '?
  def hiv?
    return self.rv == 'P' || (self.maternal_hiv == 'P' && self.rv != 'N')
  end

  def hiv_pos_mother # see hiv_pos;
    return self.maternal_hiv == 'P'
  end

  def hiv_status_word
    return {'P' => 'positive', 'N' => 'negative', 'Q' => 'unknown'}[self.rv]
  end


  ################################## MEDICATION METHODS
  # ToDo: These should probably be moved to Prescription or PrescriptionItem model!

  # Collect list of drugs recently (in last_n_months) prescribed. Return as hash:
  # { drug1 => {:date => xxx, :current => true/false, :p_item => (prescription_item cloned from actual prescription) }
  def recent_drugs(last_n_months=2)
    drugs = {}
    today = DateTime.now
    since_date = today - 30.5*last_n_months       # date to start searching from
    prescriptions = self.prescriptions.valid.where("date >= ? AND confirmed",since_date).order("date DESC")
    prescriptions.each do | p |
      p_date = p.date
      p_items = p.prescription_items
      p_items.each do | an_item |
        if not drugs.include?(an_item.drug)  # don't add older prescriptions for same drugs
          drugs[an_item.drug] = {
              :p_item => an_item.clone,
              :date => p.date,
              :current => p.date && an_item.duration && p.date + an_item.duration >= today
          }
        end
      end
    end
    return drugs
  end

  # Modify the recent_drugs list to show drugs that patient is supposedly taking at present
  def current_drugs
    recent = self.recent_drugs(6)                   # list of all drugs in past 6 months
    recent.delete_if { | key, value | not value[:current] }      # delete non-current drugs
    return recent
  end

  # Array of drugs patient is currently taking, each element a simple line of text.
  # e.g. "Isoniazid (INH) 150 mg po q24 x 30 days."
  def current_drugs_formatted
    current = self.current_drugs
    curr_f = []
    current.each do | key, c |
      p = c[:p_item]    # p is now the current prescription_item line for this drug
      curr_f << "#{key} #{p[:dose].to_s_suppress} #{p[:units]} #{p[:route]} q#{p[:interval]}h x #{p[:duration]} days."
    end
    return curr_f
  end

  def arv_begin
    most_recent = self.ptvisits.find(:first,
                                     :conditions => "arv_status = 'B' ",
                                     :order => "date DESC" )
    if most_recent.nil?                # if we didn't find B (Begin), take the oldest C (continue)
      most_recent = self.ptvisits.find(:first,
                                       :conditions => "arv_status = 'C' ",
                                       :order => "date" )

    end
    most_recent = most_recent.date unless most_recent.nil?
  end

  def arv_stop
    most_recent = self.ptvisits.find(:first,
                                     :conditions => "arv_status = 'X' ",
                                     :order => "date DESC" )
    most_recent = most_recent.date unless most_recent.nil?
  end

  def current_arv_regimen
    last_vis = self.last_visit
    return '' if last_vis.nil?
    return last_vis.arv_reg_str
  end

  def current_arv_regimen_began    # return date this regimen began, by whatever means we can find or guess
    visits = self.ptvisits.find(:all, :order => "date DESC") # if this gets to be too slow, could use SQL query to get only the needed columns
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

  def anti_tb_begin
    most_recent = self.ptvisits.find(:first,
                                     :conditions => "anti_tb_status = 'B' ",
                                     :order => "date DESC" )
    if most_recent.nil?                # if we didn't find B (Begin), take the oldest C (continue)
      most_recent = self.ptvisits.find(:first,
                                       :conditions => "anti_tb_status = 'C' ",
                                       :order => "date" )

    end
    most_recent = most_recent.date unless most_recent.nil?
  end

  def anti_tb_stop
    most_recent = self.ptvisits.find(:first,
                                     :conditions => "anti_tb_status = 'X' ",
                                     :order => "date DESC" )
    most_recent = most_recent.date unless most_recent.nil?
  end

  # Get that most recent *parameter* from *table*
  #   (*table* is expected to be already filtered for this patient, e.g.
  #    'get_last(self.visits, :weight)')
  def get_last(table,parameter)
    most_recent=table.find(:first, :order => "date DESC",
                           :conditions => "#{parameter} > ''")
    return nil if most_recent.nil?
    lastvalue = most_recent.send(parameter)
    lastdate = most_recent.date
    return {:value => lastvalue, :date_string => lastdate.strftime("%d %b %Y"), :date => lastdate }
  end

  # ToDo - Lots of refactoring of this monster method
  def get_latest_parameters()
    # may want to change this to let desired parameters be passed rather than being specified here in the method
    # This could probably be optimized, not having to do separate SQL query for each parameter
    # Should look in the latest visit (see end of this procedure) for height, weight, etc. and
    # only look at other visits (get_last) if they're not recorded in the latest visit.
    latest_parameters = {
        :cd4 => {:table => self.ptlabs, :label => "Latest CD4", :col => "cd4", :unit => ''},
        :cd4pct => {:table => self.ptlabs, :label => "Latest CD4%", :col => "cd4pct", :unit => '%'},
        :hct => {:table => self.ptlabs, :label => "Latest hct", :col => "hct", :unit => '%'},
        :wt => {:table => self.ptvisits, :label => "Latest weight", :col => "weight", :unit => ' kg'},
        :ht => {:table => self.ptvisits, :label => "Latest height", :col => "ht", :unit => ' cm'},
        :meds => {:table => self.ptvisits, :label => "Latest meds", :col => "meds", :unit => ''},
        :hiv_stage => {:table => self.ptvisits, :label => "HIV stage", :col => "hiv_stage", :unit => ''}
    }
    latest_parameters.each_value do | param_hash|
      result = self.get_last(param_hash[:table], param_hash[:col])
      if result
        param_hash.merge! result     # add the values, dates passed back by the search for latest parameters
      end
      param_hash.delete(:table)  #probably doesn't matter, makes debug viewing of the list easier
    end

    # Calculate expected weight, ht, wt for height etc.
    sex = self.sex
    height = latest_parameters[:ht][:value]
    weight = latest_parameters[:wt][:value]
    weight_date = latest_parameters[:wt][:date]
    weight_age = self.age_on_date_in_years(weight_date)
    # Strictly speaking, we can't calculate wt_for_ht unless the wt and ht are from the same
    # date, but we'll assume that the latest values are not too far apart.
    expected_height = ht_50(weight_age, sex)
    expected_weight = wt_50(weight_age, sex)
    expected_weight_for_height = wt_ht_50(height, sex)
    if height.nil? || expected_height.nil?
      pct_expected_height = '?'
    else
      pct_expected_height = (height*100/expected_height).round
    end

    if weight.nil? || expected_weight.nil?
      pct_expected_weight = '?'
    else
      pct_expected_weight = (weight*100/expected_weight).round
    end
    if weight.nil? || expected_weight_for_height.nil?
      pct_expected_wt_for_height = '?'
    else
      pct_expected_wt_for_height = (weight*100/expected_weight_for_height).round
    end
    #    latest_parameters[:weight_age] = {:value => weight_age || '?'}
    #    latest_parameters[:expected_ht] = {:value => expected_height || '?'}
    #    latest_parameters[:expected_wt] = {:value => expected_weight || '?'}
    #    latest_parameters[:expected_wt_for_ht] = {:value => expected_weight_for_height || '?'}
    latest_parameters[:pct_expected_ht] = {:value => pct_expected_height || '?'}
    latest_parameters[:pct_expected_wt] = {:value => pct_expected_weight}
    latest_parameters[:pct_expected_wt_for_ht] = {:value => pct_expected_wt_for_height}
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
    latest_visit = 	self.ptvisits.find(:first, :order => "date DESC")
    latest_parameters[:latest_visit] = latest_visit
    return latest_parameters
  end

  def last_visit
    most_recent = self.ptvisits.find(:first,
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
