# == Schema Information
#
# Table name: health_data
#
#  id                  :integer          not null, primary key
#  patient_id          :integer
#  hiv_status          :string(255)
#  maternal_hiv_status :string(255)
#  allergies           :string(255)
#  comments            :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class HealthData < ActiveRecord::Base
  belongs_to :patient
  attr_protected

  # Has HIV concern if own status is positive OR (mother's status is positive and own is not Negative)
  def hiv?
    return hiv_status == 'positive' ||
        (hiv_pos_mother && hiv_status != 'negative')
  end

  def hiv_pos
    return hiv_status == 'positive'
  end

  def hiv_pos_mother # see hiv_pos;
    return self.maternal_hiv_status == 'positive'
  end

  def hiv_status_word  # Obsolete
    hiv_status
  end

end
