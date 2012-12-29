# == Schema Information
#
# Table name: prescriptions
#
#  id          :integer          not null, primary key
#  patient_id  :integer
#  provider_id :integer
#  date        :datetime
#  filled      :boolean
#  confirmed   :boolean
#  void        :boolean
#  weight      :float
#  height      :float
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Prescription < ActiveRecord::Base
  include DateValidators
  attr_accessible :confirmed, :date, :filled, :height, :provider_id, :provider, :void, :weight,
                  :patient, :prescription_items
  attr_accessor :warnings
  accepts_nested_attributes_for :prescription_item
  belongs_to :patient
  belongs_to :provider
  has_many :prescription_items, :dependent=>:delete_all

  validates_presence_of :patient_id, :date, :provider_id
  validate :not_future

  def to_label
    date
  end

  def self.valid
    self.where("void IS ? OR NOT void",nil)
  end

  def self.confirmed
    self.where(:confirmed=>true)
  end

  def items
    self.prescription_items
  end

  # Check whether this prescription contains an item (usually a drug) p_item
  # For now, just a wrapper around a 'find'. Return the item if it exists, or nil.
  # Assumes that the name of the drug is entered only in the "official" way, not abbreviated
  # or with another name etc. (although wildcard matching is used). The prescription entry methods should check this, at least
  # for drugs that will be checked by include.
  def include?(p_item)
    target = Regexp.new(p_item,'i') # create regular expression for case-insensitive comparison
    for itm in self.prescription_items
      return itm if target =~ itm.drug
    end
    return nil
  end

#protected

  def interaction_warning(drugs_1, drugs_2, options={})
    warning_type = options[:warning_type] || :Caution
    warning_message = options[:message] || 'Potential drug interaction:'
    override = options[:override] || false
    contains_1 = nil
    contains_2 = nil
    for drug in drugs_1
      contains_1 = drug if self.include?(drug)  # set contains_1 to the drug found, if there is one
      break if contains_1 # if found, no need to continue the loop
    end
    return nil unless contains_1  # first drug not found, so no need to look for second
    for drug in drugs_2
      contains_2 = drug if self.include?(drug)  # look for a drug in the second set
      break if contains_2  # second drug found?
    end
    return nil unless contains_2  # second drug not found, so return
                                  # At this point, we have a match on the two "interacting" drugs, so will issue warning
    warning_string =  "#{warning_message} #{contains_1}, #{contains_2}."
#ORIG    if !overrideable || override_warning.blank?   # Do not override
#          errors.add(warning_type, warning_string)
#        else
#          self.warnings << warning_string
#        end
    if override   # Do not override
      @warnings = (@warnings || []) << warning_string
    else
      errors.add(warning_type.to_sym, warning_string)
    end

    return [contains_1, contains_2]
  end

  # For now, put everything here. Will probably want to refactor for different conditions etc.
  # Validation potentially includes not only syntactical problems but physiologic ones such as
  # conflicting choice of drugs, wrong doses, age inappropriate, etc.
  # NEVIRAPINE AND RIFAMPACIN
  def validate
    self.warnings = ''
    interaction_warning(['nevirapine', 'kaletra', 'lopinavir'], ['rifampacin'])
    interaction_warning(['zidovudine'],['stavudine'],'Error:', 'these drugs cannot be used together.')
    interaction_warning(['carbamazepine'], ['kaletra', 'efavirenz'], 'Caution:',
                        'possible interaction, levels of both drugs may be decreased, avoid combination if possible')
    interaction_warning(['metronidazole', 'tinidazole'], ['kaletra'], 'Caution:',
                        'possible interaction if Kaletra syrup used; disulfiram-type reaction with alcohol in syrup.')
    interaction_warning(['ketoconazole'], ['kaletra', 'efavirenz', 'nevirapine'], 'Caution:',
                        'possible significant interactions. Check reference and consider using fluconazole.')
    interaction_warning(['phenobarbitone'], ['kaletra', 'efavirenz'], 'Caution:',
                        'possible significant interactions. Check reference and avoid combination if possible.')
    interaction_warning(['phenytoin'], ['kaletra', 'efavirenz'], 'Caution:',
                        'possible interaction, levels of ARV may be decreased, avoid combination if possible')
    interaction_warning(['erythromycin'], ['carbamazepine'], 'Caution:',
                        'interaction, levels of CBZ may be increased causing symptoms of nystagmus, nausea, vomiting, and ataxia; avoid combination if possible')

  end


end
