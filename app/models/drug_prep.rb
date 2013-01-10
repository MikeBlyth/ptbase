# == Schema Information
#
# Table name: drug_preps
#
#  id         :integer          not null, primary key
#  drug_id    :integer
#  xform      :string(255)
#  strength   :string(255)
#  mult       :float
#  quantity   :string(255)
#  buy_price  :float
#  stock      :float
#  synonyms   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class DrugPrep < ActiveRecord::Base
  attr_accessible :buy_price, :xform, :mult, :quantity, :stock, :strength, :synonyms, :drug_id
  belongs_to :drug
  validates_presence_of :xform, :drug_id

  def to_label
    "#{xform} #{strength}"
  end
end
