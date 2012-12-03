FactoryGirl.define do
  factory :patient do
    sequence(:last_name) {|n| "LastNameA_#{n}" }
    sequence(:first_name) {|n| "First_#{n}" }
    sequence(:ident) {|n| "P_#{n}" }
    sex 'M'
    birth_date '2000-1-1'
  end

  factory :admin_user do
    email 'test@example.com'
  end
end
