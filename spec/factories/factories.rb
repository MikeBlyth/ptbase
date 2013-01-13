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
    xform 'tablet'
    strength '250 mg'
    drug
  end

  factory :health_data do
    patient

    trait :hiv_pos do
      hiv_status 'positive'
    end

    trait :hiv_neg do
      hiv_status 'negative'
    end

    trait :maternal_hiv do
      maternal_hiv_status 'positive'
    end

  end

  factory :icd9 do
    sequence(:icd9) {|n| n.to_s}
    sequence(:description) {|n| "disease #{n}"}
  end

  factory :immunization do
    patient
    bcg {patient.birth_date.to_date + 2.weeks}
    opv1 {patient.birth_date.to_date + 2.weeks }
    dpt1 {patient.birth_date.to_date + 2.weeks  }
    dpt2 {patient.birth_date.to_date + 6.weeks  }
  end

  #factory :lab do
  #  date '2009-04-15'
  #  patient
  #  hct 40
  #  wbc 5700
  #
  #  trait :hi_cd4 do
  #    cd4 3000
  #    cd4pct 25
  #  end
  #
  #  trait :lo_cd4 do
  #    cd4 100
  #    cd4pct 8
  #  end
  #
  #  trait :anemic do
  #    hct 23
  #  end
  #
  #  trait :hiv_pos do
  #    hiv_screen 'positive'
  #  end
  #
  #  trait :hiv_neg do
  #    hiv_screen 'negative'
  #  end
  #
  #end

  factory :lab_group do
    sequence(:name) {|n| "Lab Group #{n}"}
    sequence(:abbrev) {|n| "LabGrp_#{n}"}
  end

  factory :lab_service do
    sequence(:name) {|n| "Lab Service #{n}"}
    sequence(:abbrev) {|n| "lab_#{n}"}
    unit 'mMol'
    lab_group
    #association :lab_group, strategy: :build
    #after(:build) do |lab_service|
    #  lab_service.lab_group = LabGroup.first || LabGroup.create(name: 'Lab Group', abbrev: 'LabGrp')
    #end
  end

  factory :lab_request do
    #date {Date.yesterday}
    patient
    provider
  end

  factory :lab_result do
    lab_service
    result '50'
    lab_request
    date {Date.today}
  end

  factory :patient do
    sequence(:last_name) {|n| "LastNameA_#{n}" }
    sequence(:first_name) {|n| "First_#{n}" }
    sequence(:ident) {|n| "P_#{n}" }
    sex 'M'
    birth_date '2000-1-1'

    factory :patient_with_health_data do
      health_data
    end

  end

  factory :prescription do
    patient
    date '2010-05-14'
    provider

    trait :recent do
      date {Date.yesterday}
    end

    trait :old do
      date '2000-01-01'
    end

    trait :void do
      void true
    end

    trait :confirmed do
      confirmed true
    end

    trait :filled do
      filled true
    end

    factory :prescription_with_item do
      after(:build) {|p|
        item = FactoryGirl.build(:prescription_item, prescription_id: 0)
        puts "Item errors = #{item.errors.messages}" unless item.valid?
        p.prescription_items << item
      }
    end

  end


  factory :prescription_item do
    prescription
    sequence(:drug) {|n| %w(ampicillin penicillin amoxycillin doxycycline)[(n-1).modulo(4)]}
    dose '250 mg'
    unit 'tab'
    route 'po'
    interval 6
    duration 6

    factory :prescription_item_without_prescription do
        prescription nil
      end
  end

  factory :photo do
    date '2009-1-1'
    patient
    comments 'Comment on photo'
  end

  factory :problem do
    patient
    date '2010-1-1'
    description 'malaria'

    trait :resolved do
      resolved '2010-1-4'
    end

    trait :chronic do
      resolved nil
      description 'juvenile rheumatoid arthritis'
    end
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

    trait :recent do
      date {Date.yesterday}
    end

    trait :old do
      date '2000-01-01'
    end

  end
end
