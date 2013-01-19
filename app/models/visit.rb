# == Schema Information
#
# Table name: visits
#
#  id                         :integer          not null, primary key
#  patient_id                 :integer
#  date                       :datetime
#  next_visit                 :datetime
#  dx                         :string(255)
#  dx2                        :string(255)
#  comments                   :string(255)
#  weight                     :float
#  height                     :float
#  head_circ                  :float
#  meds                       :string(255)
#  newdx                      :boolean
#  newpt                      :boolean
#  adm                        :boolean
#  sbp                        :integer
#  dbp                        :integer
#  scheduled                  :boolean
#  provider_id                :integer
#  hiv_stage                  :string(255)
#  arv_status                 :string(255)
#  anti_tb_status             :string(255)
#  reg_zidovudine             :boolean
#  reg_stavudine              :boolean
#  reg_lamivudine             :boolean
#  reg_didanosine             :boolean
#  reg_nevirapine             :boolean
#  reg_efavirenz              :boolean
#  reg_kaletra                :boolean
#  hpi                        :text
#  temperature                :float
#  development                :text
#  assessment                 :text
#  plan                       :text
#  mid_arm_circ               :float
#  resp_rate                  :integer
#  heart_rate                 :integer
#  phys_exam                  :text
#  diet_breast                :boolean
#  diet_breastmilk_substitute :boolean
#  diet_pap                   :boolean
#  diet_solids                :boolean
#  assessment_stable          :boolean
#  assessment_oi              :boolean
#  assessment_drug_toxicity   :boolean
#  assessment_nonadherence    :boolean
#  arv_missed                 :integer
#  arv_missed_week            :integer
#  created_at                 :datetime
#  updated_at                 :datetime
#  arv_regimen                :string(255)
#  symptoms                   :hstore
#  exam                       :hstore
#  diagnoses                  :hstore
#

# ToDo Refactor to Vital signs, diagnoses, visit info (date, time, provider), etc.
class Visit < ActiveRecord::Base
  include DateValidators

  belongs_to :patient
  belongs_to :provider
  attr_protected
  validates_presence_of :date, :patient_id
  validate :not_future
 # validate :next_visit_future
  validates :weight, numericality: {greater_than: 0}, allow_nil: true
  validates :weight, numericality: {less_than: 300}, allow_nil: true
  validates :height, numericality: {greater_than: 0}, allow_nil: true
  validates :height, numericality: {less_than: 240}, allow_nil: true
  validates :sbp, numericality: {less_than: 400}, allow_nil: true
  validates :dbp, numericality: {less_than: 250}, allow_nil: true
  validates :head_circ, numericality: {less_than: 140}, allow_nil: true
  validates :head_circ, numericality: {greater_than: 14}, allow_nil: true

  # Return formatted string listing ARVs being used at time of this visit
  # ToDo - Refactor completely -- probably should have separate ARV model or at least record per visit of
  #   pts use of ARV. I don't think this one will even work as it refers to what looks like
  #   params returned from a form (reg_ ...)
  def arv_reg_str
    arvs = [
        ['zidovudine' ,  'ZDV'],
        [ 'stavudine' ,  'd4T (stav)'],
        [ 'lamivudine' ,  '3TC'],
        [ 'didanosine' ,  'ddI'],
        [ 'nevirapine' ,  'NVP'],
        [ 'efavirenz' ,  'EFV'],
        [ 'kaletra' ,  'kaletra']
    ]
    s = ''
    arvs.each do | arv |
      being_used = self.send('reg_'+arv[0])
      s << ', ' + arv[1]  if being_used  # add abbreviation of each arv being used e.g. "zdv, 3tc, nvp"
    end
    return s[2,100]    # trim off the first comma and space   NB: Gives nil if s was ''
  end

  # ToDo Refactor these, probably don't want to use single character codes, ...
  # ARV and Anti-TB Status Codes
  # 0 (zero) = not on
  # P = preparing, planning
  # B = begin
  # C = continue
  # X = Stop
  # V = change


  def self.starting_arv
    self.where("arv_status =?", 'B')
  end

  def self.continuing_arv
    self.where("arv_status =?", 'C')
  end

  def self.stopping_arv
    self.where("arv_status =?", 'X')
  end

  def to_label
    date
  end

  def diagnoses_array
    Visit.column_names.select{|col| col =~ /\Adx_/ && self.send(col)}.
        map {|dx| Diagnosis.find_by_name(dx[3..-1])}.compact
  end

  def diagnosis_labels
    diagnoses_array.map{|dx| dx.to_label}
  end

  # Default sort order will be on date
  def <=>(x,y)
    x.date <=> y.date
  end

  private
  def next_visit_future
    errors.add(:next_visit, 'date cannot be in the past') if next_visit && (next_visit < DateTime.now)
  end
end
