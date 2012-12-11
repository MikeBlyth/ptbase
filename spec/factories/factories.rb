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

  factory :immunization do
    patient
    bcg {patient.birth_date.to_date + 2.weeks}
    opv1 {patient.birth_date.to_date + 2.weeks }
    dpt1 {patient.birth_date.to_date + 2.weeks  }
    dpt2 {patient.birth_date.to_date + 6.weeks  }
  end

  factory :lab do
    date '2009-04-15'
    patient
    hct 40
    wbc 5700

    trait :hi_cd4 do
      cd4 3000
      cd4pct 25
    end

    trait :lo_cd4 do
      cd4 100
      cd4pct 8
    end

    trait :anemic do
      hct 23
    end

    trait :hiv_pos do
      hiv_screen 'positive'
    end

    trait :hiv_neg do
      hiv_screen 'negative'
    end

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
    units 'tab'
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
