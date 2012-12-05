FactoryGirl.define do

  factory :admission do
    date '2008-01-01'
    diagnosis_1 'pneumonia'
    patient
  end

  factory :diagnosis do
    name 'pneumonia'
  end

  factory :drug do
    sequence(:name) {|n| "amoxycillin_#{n}"}
    drug_class 'antibiotic'
    drug_subclass 'penicillin'
    synonyms 'amoxacillin; amoxyl; amoxil'
  end

  factory :drug_prep do
    form 'tablet'
    strength '250 mg'
    drug
  end

  factory :immunization do
    date '2009-04-15'
    patient
    bcg 'given'
    opv1 'given'
  end

  factory :lab do
    date '2009-04-15'
    patient
    hct 47
    wbc 5700
  end

  factory :patient do
    sequence(:last_name) {|n| "LastNameA_#{n}" }
    sequence(:first_name) {|n| "First_#{n}" }
    sequence(:ident) {|n| "P_#{n}" }
    sex 'M'
    birth_date '2000-1-1'
  end

  factory :prescription do
    patient
    date '2010-05-14'
    prescriber
  end


  factory :prescription_item do
    prescription
    drug 'ampicillin'
    dose '250 mg'
    units 'tab'
    route 'po'
    interval 6
    duration 6
  end

  factory :photo do
    date '2009-1-1'
    patient
    comments 'Comment on photo'
  end

  factory :provider, aliases: [:prescriber] do
    last_name 'Hertz'
    first_name 'Joshua'
    other_names 'Kernigan'
    sequence(:ident) {|n| "Prov #{n}"  }
  end

  factory :admin_user do
    email 'test@example.com'
  end

  factory :visit do
    date '2008-01-01'
    patient
  end
end
