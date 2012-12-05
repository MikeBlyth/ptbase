# == Schema Information
#
# Table name: drug_preps
#
#  id         :integer          not null, primary key
#  drug_id    :integer
#  form       :string(255)
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
  attr_accessible :buy_price, :form, :mult, :quantity, :stock, :strength, :synonyms
  belongs_to :drug
  validates_presence_of :form
end
