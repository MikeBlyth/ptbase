# == Schema Information
#
# Table name: labs
#
#  id            :integer          not null, primary key
#  patient_id    :integer
#  categories    :string(255)
#  date          :datetime
#  wbc           :integer
#  neut          :integer
#  lymph         :integer
#  bands         :integer
#  eos           :integer
#  hct           :integer
#  retic         :float
#  esr           :integer
#  platelets     :integer
#  malaria_smear :string(255)
#  csf_rbc       :integer
#  csf_wbc       :integer
#  csf_lymph     :integer
#  csf_neut      :integer
#  csf_protein   :integer
#  csf_glucose   :string(255)
#  csf_culture   :string(255)
#  blood_glucose :integer
#  urinalysis    :string(255)
#  bili          :float
#  hiv_screen    :string(255)
#  hiv_antigen   :string(255)
#  wb            :string(255)
#  mantoux       :string(255)
#  hb_elect      :string(255)
#  other         :string(255)
#  creat         :float
#  cd4           :integer
#  cd4pct        :integer
#  amylase       :integer
#  sgpt          :integer
#  sgot          :integer
#  hbsag         :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  provider_id   :integer
#

class Lab < ActiveRecord::Base
  include DateValidators
  attr_protected :patient_id
  belongs_to :patient
  belongs_to :provider
  validates_presence_of :date, :patient_id
  validate :not_future
  validate :valid_lab_results

  def to_label
    date
  end

  # Calculated values
  def tlc    # Total lymphocyte count
    return nil if self.wbc.nil? or self.lymph.nil? or self.wbc == 0 or self.lymph == 0
    return ( wbc * lymph / 100)
  end

  def anc    # Absolute neutrophil count
    return nil if self.wbc.nil? or self.neut.nil? or self.wbc == 0 or self.neut == 0
    return ( wbc * neut / 100)
  end

  def aec    # Absolute eosinophil count
    return nil if self.wbc.nil? or self.eos.nil? or self.wbc == 0 or self.eos == 0
    return ( wbc * eos / 100)
  end

protected

  # ToDo isn't there a built-in range validator now?
  # ToDo Remove duplication of col and val
  def valid_range (col, val, min, max)
    errors.add(col,'invalid') unless val.blank? || val.between?(min,max)
  end

  # ToDo These values probably belong in a table, not hard coded
  def valid_lab_results
    valid_range(:wbc, wbc, 0, 200000)
    valid_range(:neut, neut, 0, 100)
    valid_range(:lymph, lymph, 0, 100)
    valid_range(:bands, bands, 0, 100)
    valid_range(:eos, eos, 0, 100)
    valid_range(:hct, hct, 0, 80)
    valid_range(:retic, retic, 0, 70)
    valid_range(:platelets, plts, 0, 1000000)
    valid_range(:esr, esr, 0, 250)
    valid_range(:blood_glucose, blood_glucose, 0, 1000)
    valid_range(:bili, bili, 0, 100)
    valid_range(:creat, creat, 0, 100)
    valid_range(:cd4, cd4, 0, 10000)
    valid_range(:cd4pct, cd4pct, 0, 100)
    valid_range(:amylase, amylase, 0, 5000)
    valid_range(:sgpt, sgpt, 0, 10000)
    valid_range(:sgot, sgot, 0, 10000)
    errors.add(:neut, 'Invalid differential -- total > 100%') if (neut || 0) + (lymph || 0) + (bands || 0) + (eos || 0) > 102
  end
end
