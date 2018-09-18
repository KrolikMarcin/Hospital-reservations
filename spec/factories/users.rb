FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@wp.pl" }
    sequence(:first_name) { |n| "Jonasz#{n}" }
    sequence(:last_name) { |n| "Koc#{n}" }
    pesel { Random.new.rand(10**8..999_999_999).to_i }
    password { 'asdasd' }
    employee { false }

    trait :employee do
      employee { true }
      sequence(:specialization) { |n| "specialization#{n}" }
    end

    trait :admin do
      admin { true }
      employee { true }
    end
  end
  factory :user_employee, traits: [:user, :employee]
end
