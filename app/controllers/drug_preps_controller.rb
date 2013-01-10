class DrugPrepsController < ApplicationController
  active_scaffold :drug_prep do |config|
    config.label = 'Drug Preparations'
    config.columns = [:drug, :xform, :strength, :mult, :quantity, :stock, :buy_price, :synonyms]
    config.columns[:xform].label = 'Form'
  end
end
