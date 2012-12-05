# == Schema Information
#
# Table name: visits
#
#  id                      :integer          not null, primary key
#  patient_id              :integer
#  date                    :datetime
#  next_visit              :datetime
#  dx                      :string(255)
#  dx2                     :string(255)
#  comments                :string(255)
#  weight                  :float
#  ht                      :float
#  head_circ               :float
#  meds                    :string(255)
#  newdx                   :boolean
#  newpt                   :boolean
#  adm                     :boolean
#  sbp                     :integer
#  dbp                     :integer
#  sx_wt_loss              :boolean
#  sx_fever                :boolean
#  sx_headache             :boolean
#  sx_diarrhea             :boolean
#  sx_numbness             :boolean
#  sx_nausea               :boolean
#  sx_rash                 :boolean
#  sx_vomiting             :boolean
#  sx_cough                :boolean
#  sx_night_sweats         :boolean
#  sx_visual_prob_new      :boolean
#  sx_pain_swallowing      :boolean
#  sx_short_breath         :boolean
#  sx_other                :string(255)
#  dx_hiv                  :boolean
#  dx_tb_pulm              :boolean
#  dx_pneumonia            :boolean
#  dx_malaria              :boolean
#  dx_uri                  :boolean
#  dx_acute_ge             :boolean
#  dx_otitis_media_acute   :boolean
#  dx_otitis_media_chronic :boolean
#  dx_thrush               :boolean
#  dx_tinea_capitis        :boolean
#  dx_scabies              :boolean
#  dx_parotitis            :boolean
#  dx_dysentery            :boolean
#  scheduled               :boolean
#

class Visit < ActiveRecord::Base
  include DateValidators

  belongs_to :patient
  attr_protected
  validates_presence_of :date, :patient_id
  validate :not_future
  validate :next_visit_future

  private
  def next_visit_future
    errors.add(:next_visit, 'date cannot be in the past') if next_visit && (next_visit < DateTime.now)
  end
end
